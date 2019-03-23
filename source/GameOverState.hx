package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class GameOverState extends FlxState {	
	override public function create() {
		super.create();

		var winnerText = new FlxText(0, 300, 0, "", 40);
		winnerText.text = Reg.leftPlayerHearts > Reg.rightPlayerHearts ? "Player 1 wins!" : "Player 2 wins!";
		winnerText.screenCenter(X);
		add(winnerText);

		var restartText = new FlxText(0, 500, 0, "", 24);
		restartText.text = "Press R to restart";
		restartText.screenCenter(Y);
		add(restartText);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
