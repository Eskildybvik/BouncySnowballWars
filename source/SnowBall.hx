package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class SnowBall extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(24, 24, FlxColor.BLUE);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
