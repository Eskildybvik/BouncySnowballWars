package;

import flixel.input.gamepad.id.LogitechID;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
	private var midline:FlxSprite;

	override public function create():Void {
		super.create();

		midline = new FlxSprite(0, 0);
		midline.makeGraphic(8, FlxG.height, FlxColor.RED);
		midline.screenCenter(X);
		add(midline);

		add(new Player(128, 128)); // temporary
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
