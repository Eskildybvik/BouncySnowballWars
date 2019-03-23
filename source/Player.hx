package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(64, 64, FlxColor.CYAN);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
