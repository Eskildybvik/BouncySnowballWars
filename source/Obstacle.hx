package; 

import flixel.FlxSprite;

class Obstacle extends FlxSprite {
	private var framesUntilCanBeDamagedAgain:Int = 0; // Used to prevent double damaging

	public function new(x:Float, y:Float) {
		super(x, y);
		health = 3;
		immovable = true;
		loadGraphic(AssetPaths.Obstacle__png, true, 50, 50);
	}

	override public function update(elapsed:Float) {
		framesUntilCanBeDamagedAgain--;
		super.update(elapsed);
	}

	public function damage() {
		if (framesUntilCanBeDamagedAgain > 0) return;
		framesUntilCanBeDamagedAgain = 4;
		health--;
		if (health == 0) destroy();
	}
}

