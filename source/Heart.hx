package;

import flixel.FlxSprite;

class Heart extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/Heart big.png", true, 64, 64);
		animation.add("full", [1], 1, false);
		animation.add("destroy", [2, 3, 4, 0], 4, false);
		animation.play("full");
	}

	public function clear() {
		animation.play("destroy");
		alive = false;
	}
}