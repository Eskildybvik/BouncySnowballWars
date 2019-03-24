package;

import flixel.FlxSprite;
import flixel.FlxObject;


class SnowBall extends FlxSprite {
	private var framesUntilTouchCheck:Int = 0; // Jallafix for bad collisions
	private var bouncesLeft:Int = 3;
	public var inUse:Bool = false;
	private var framesUntilActive = 12;

	public function new(x:Float, y:Float) {
		super(x, y);
		// loadGraphic(AssetPaths.Snowball__png);
		loadGraphic("assets/images/Snowball explode.png", true, 100, 100);
		animation.add("fly", [0], 1, false);
		animation.add("smash", [1, 2, 3, 4], 16, false);
		animation.play("fly");
		setSize(24, 24);
		offset.set(38, 38);
	}

	override public function update(elapsed:Float) {
		if (framesUntilActive > 0) {
			framesUntilActive--;
			if (framesUntilActive == 0) {
				inUse = true;
			}
		}

		if (framesUntilTouchCheck == 0) {
			if (isTouching(FlxObject.LEFT)) {
				velocity.set(Math.abs(velocity.x), velocity.y);
				framesUntilTouchCheck = 2;
				bouncesLeft--;
			}
			else if (isTouching(FlxObject.RIGHT)) {
				velocity.set(Math.abs(velocity.x) * -1, velocity.y);
				framesUntilTouchCheck = 2;
				bouncesLeft--;
			}
			else if (isTouching(FlxObject.FLOOR)) {
				velocity.set(velocity.x, -1*Math.abs(velocity.y));
				framesUntilTouchCheck = 2;
				bouncesLeft--;
			}
			else if (isTouching(FlxObject.CEILING)) {
				velocity.set(velocity.x, Math.abs(velocity.y));
				framesUntilTouchCheck = 2;
				bouncesLeft--;
			}
		}
		else {
			framesUntilTouchCheck--;
		}
		super.update(elapsed);

		if (bouncesLeft == 0) {
			kill();
		}
	}

	override public function kill() {
		velocity.scale(0.05);
		inUse = false; 
		animation.play("smash");
		animation.finishCallback = function(s:String) {
			justCallSuperKill();
			// Be ready for recycling
			bouncesLeft = 3;
			framesUntilActive = 12;
			animation.finishCallback = null;
			animation.play("fly"); 
		}
	}

	// super.kill() couldn't be used in a local function.
	private function justCallSuperKill() {
		super.kill();
	}
}
