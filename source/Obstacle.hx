package; 

import flixel.FlxSprite;

class Obstacle extends FlxSprite {
	private var framesUntilCanBeDamagedAgain:Int = 0; // Used to prevent double damaging

	public function new(x:Float, y:Float) {
		super(x, y);
		health = 3;
		immovable = true;
		loadGraphic("assets/images/ObstacleDestroy.png", true, 64, 90);
		setSize(64, 64);
		offset.y = 22;
		animation.add("hp3", [0], 1, false);
		animation.add("hp2", [1], 1, false);
		animation.add("hp1", [2], 1, false);
		animation.add("destroy", [3, 4, 5], 8, false);
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

