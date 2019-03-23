package;

import flixel.FlxSprite;
import flixel.FlxObject;


class SnowBall extends FlxSprite {
	private var framesUntilTouchCheck:Int = 0; // Jallafix for bad collisions
	private var bouncesLeft:Int = 3;
	public var inUse:Bool = false;
	private var framesUntilActive = 5;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(AssetPaths.Snowball__png);
	}

	override public function update(elapsed:Float) {
		if (framesUntilActive > 0) framesUntilActive--;
		else inUse = true;

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
			bouncesLeft = 3; // To be ready for revival
		}
	}
}
