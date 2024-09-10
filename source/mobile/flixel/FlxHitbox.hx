package mobile.flixel;

import flixel.util.FlxGradient;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDestroyUtil;
import mobile.flixel.FlxButton;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.display.BitmapData;
import openfl.display.Shape;
import backend.ExtraKeysHandler;

class FlxHitbox extends FlxSpriteGroup {
	public var hitbox:FlxSpriteGroup;
	public var hints:FlxSpriteGroup;

	public var array:Array<FlxButton> = [];

	public function new(?type:Int = 3) {
		super();
		hitbox = new FlxSpriteGroup();
		hints = new FlxSpriteGroup();
		
		var keyCount:Int = type + 1;
		var hitboxWidth:Int = Math.floor(FlxG.width / keyCount);
		for (i in 0 ... keyCount) {
			var hitboxColor:String = (ClientPrefs.data.dynamicColors ? getDynamicColor(type, i) :  ExtraKeysHandler.instance.data.hitboxColors[type][i]);
			hitbox.add(add(array[i] = createHitbox(hitboxWidth * i, 0, hitboxWidth, FlxG.height, hitboxColor)));
			array[i].stringIDs = ['${type}_key_${keyCount}'];
			if (!ClientPrefs.data.hideHitboxHints)
			    hints.add(add(createHints(hitboxWidth * i, 0, hitboxWidth, FlxG.height, hitboxColor)));
		}
	}

	public function createHitbox(x:Float = 0, y:Float = 0, width:Int, height:Int, color:String) {
		var button:FlxButton = new FlxButton(x, y);
		button.loadGraphic(createHitboxGraphic(width, height));
		button.updateHitbox();
		button.alpha = 0;
		button.color = CoolUtil.colorFromString(color);

		button.onDown.callback = function() button.alpha = ClientPrefs.data.controlsAlpha;
		button.onUp.callback = function() button.alpha = 0;
		button.onOut.callback = function() button.alpha = 0;

		return button;
	}

	public function createHints(x:Float = 0, y:Float = 0, width:Int, height:Int, color:String) {
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(3, 0xFFFFFF, 1);
		shape.graphics.drawRect(0, 0, width, height);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRect(3, 3, width - 6, height - 6);
		shape.graphics.endFill();
		
		var bitmap:BitmapData = new BitmapData(width, height, true, 0);
		bitmap.draw(shape);
 
        var hintSpr:FlxSprite = new FlxSprite(x, y, bitmap);
		hintSpr.updateHitbox();
		hintSpr.color = CoolUtil.colorFromString(color);

		return hintSpr;
	}

	function createHitboxGraphic(Width:Int, Height:Int):BitmapData
	{
		var guh = ClientPrefs.data.controlsAlpha;
		if (guh >= 0.9)
			guh = ClientPrefs.data.controlsAlpha - 0.07;
 
		var shape:Shape = new Shape();
		shape.graphics.beginGradientFill(RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [guh, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(3, 0xFFFFFF, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);

		return bitmap;
	}
	
	//get color from note function
	function getDynamicColor(type:Int, int:Int):String {
	    var notes:Int = ExtraKeysHandler.instance.data.keys[type].notes[int];
	    return CoolUtil.getArrowRGB('arrowRGB.json', ExtraKeysHandler.instance.data.colors).colors[notes].inner;
 	}

	override public function destroy():Void {
		super.destroy();

		hitbox = FlxDestroyUtil.destroy(hitbox);
		hints = FlxDestroyUtil.destroy(hints);

		for (hbox in array) {
			hbox = null;
		}
	}
}
