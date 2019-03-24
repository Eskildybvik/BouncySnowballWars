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

		FlxG.sound.music.stop();

		var winnerText = new FlxText(0, 300, 0, "", 40);
		winnerText.text = Reg.leftPlayerHearts > Reg.rightPlayerHearts ? "Player 1 wins!" : "Player 2 wins!";
		winnerText.screenCenter(X);
		add(winnerText);

		var winnerIcon = new FlxSprite(0, 0);
		winnerIcon.loadGraphic(Reg.leftPlayerHearts > Reg.rightPlayerHearts ? "assets/images/Player1win.png" : "assets/images/Player2win.png");
		winnerIcon.screenCenter();
		add(winnerIcon);

		var restartText = new FlxText(0, 500, 0, "", 24);
		restartText.text = "Press R to restart";
		restartText.screenCenter(X);
		add(restartText);
	}

	override public function update(elapsed:Float) {
		if (gamepad == null) {
			gamepad = FlxG.gamepads.getFirstActiveGamepad();
		}
		if (FlxG.keys.justReleased.R || (gamepad != null ? gamepad.anyJustReleased([A, B]) : false)) {
			Reg.leftPlayerHearts = Reg.rightPlayerHearts = 5;
			Reg.leftPlayerSnow = Reg.rightPlayerSnow = 30;
			FlxG.resetGame();
		}
		super.update(elapsed);
	}
}
