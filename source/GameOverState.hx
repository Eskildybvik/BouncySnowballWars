package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class GameOverState extends FlxState {	
	
	private var gamepad:FlxGamepad = null;

	override public function create() {
		super.create();

		var winnerText = new FlxText(0, 300, 0, "", 40);
		winnerText.text = Reg.leftPlayerHearts > Reg.rightPlayerHearts ? "Player 1 wins!" : "Player 2 wins!";
		winnerText.screenCenter(X);
		add(winnerText);

		var restartText = new FlxText(0, 500, 0, "", 24);
		restartText.text = "Press any button to restart";
		restartText.screenCenter(X);
		add(restartText);
	}

	override public function update(elapsed:Float) {
		if (gamepad == null) {
			gamepad = FlxG.gamepads.getFirstActiveGamepad();
		}
		if (FlxG.keys.justReleased.ANY || gamepad != null ? gamepad.justReleased.ANY : false) {
			Reg.leftPlayerHearts = Reg.rightPlayerHearts = 5;
			Reg.leftPlayerSnow = Reg.rightPlayerSnow = 30;
			FlxG.resetGame();
		}
		super.update(elapsed);
	}
}
