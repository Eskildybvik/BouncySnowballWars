package;

import flixel.FlxSprite;

class Heart extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/Heart big.png", true, 32, 32);
		animation.add("full", [1], 1, false);
		animation.add("destroy", [2, 3, 4, 0], 8, false);
		animation.play("full");
	}

	public function clear() {
		animation.play("destroy");
		alive = false;
	}
}