package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class GameOverState extends FlxState {	
	
	private var gamepad1:FlxGamepad = null;
	private var gamepad2:FlxGamepad = null;

	override public function create() {
		super.create();

		FlxG.sound.music.stop();

		var winnerText = new FlxText(0, 480, 0, "", 40);
		winnerText.text = Reg.leftPlayerHearts > Reg.rightPlayerHearts ? "Player 1 wins!" : "Player 2 wins!";
		winnerText.screenCenter(X);
		add(winnerText);

		var winnerIcon = new FlxSprite(0, 180);
		winnerIcon.loadGraphic(Reg.leftPlayerHearts > Reg.rightPlayerHearts ? "assets/images/Player1win.png" : "assets/images/Player2win.png");
		winnerIcon.screenCenter(X);
		add(winnerIcon);

		var restartText = new FlxText(0, 600, 0, "", 24);
		restartText.text = "Press R to restart";
		restartText.screenCenter(X);
		add(restartText);
	}

	override public function update(elapsed:Float) {
		if (gamepad1 == null) {
			gamepad1 = FlxG.gamepads.getFirstActiveGamepad();
		}
		else if (gamepad2 == null && FlxG.gamepads.getFirstActiveGamepad() != gamepad1){
			gamepad2 = FlxG.gamepads.getFirstActiveGamepad();
		}
		if (FlxG.keys.justReleased.R || (gamepad1 != null ? gamepad1.anyJustReleased([A, B]) : false) || (gamepad2 != null ? gamepad2.anyJustReleased([A, B]) : false)) {
			Reg.leftPlayerHearts = Reg.rightPlayerHearts = 5;
			Reg.leftPlayerSnow = Reg.rightPlayerSnow = 5;
			FlxG.resetGame();
		}
		super.update(elapsed);
	}
}
