package; 

import flixel.FlxSprite;

class Obstacle extends FlxSprite {
	private var framesUntilCanBeDamagedAgain:Int = 0; // Used to prevent double damaging
	public var inUse = false; // False while building

	public function new(x:Float, y:Float) {
		super(x, y);
		health = 3;
		immovable = true;
		loadGraphic("assets/images/obstacle.png", true, 64, 90);
		setSize(64, 64);
		offset.y = 22;
		animation.add("build", [0, 1, 2], 4, false);
		animation.add("hp3", [3], 1, false);
		animation.add("hp2", [4], 1, false);
		animation.add("hp1", [5], 1, false);
		animation.add("destroy", [6, 7, 8], 8, false);
		animation.finishCallback = function (s:String) {
			inUse = true;
		}
		animation.play("build");
	}

	override public function update(elapsed:Float) {
		framesUntilCanBeDamagedAgain--;
		super.update(elapsed);
	}

	public function damage() {
		if (framesUntilCanBeDamagedAgain > 0) return;
		framesUntilCanBeDamagedAgain = 4;
		health--;
		if (health == 0) controlledDestruction();
		else if (health > 0) animation.play("hp" + health);
	}

	private function controlledDestruction() {
		animation.play("destroy");
		animation.finishCallback = function(s:String) {
			destroy();
		}
	}
}

