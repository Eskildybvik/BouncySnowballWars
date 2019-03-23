package;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	private static inline var PLAYER_SPEED:Int = 100;

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(64, 64, FlxColor.CYAN);
		drag.set(PLAYER_SPEED*8, PLAYER_SPEED*8);
		maxVelocity.set(PLAYER_SPEED, PLAYER_SPEED);
	}

	override public function update(elapsed:Float) {
		controls();
		super.update(elapsed);
	}

	private function controls() {
		var tUp = FlxG.keys.pressed.W;
		var tLeft = FlxG.keys.pressed.A;
		var tDown = FlxG.keys.pressed.S;
		var tRight = FlxG.keys.pressed.D;

		var tAngle = 0;
		var tWillMove = false;

		if (tUp) {
			tWillMove = true;
			tAngle = -90;
			if (tLeft) {
				tAngle -= 45;
			}
			if (tRight) {
				tAngle += 45;
			}
		}
		else if (tDown) {
			tWillMove = true;
			tAngle = 90;
			if (tLeft) {
				tAngle += 45;
			}
			if (tRight) {
				tAngle -= 45;
			}
		}
		else if (tRight) {
			tWillMove = true;
			tAngle = 0;
		}
		else if (tLeft) {
			tWillMove = true;
			tAngle = 180;
		}

		if (tWillMove) {
			velocity.set(PLAYER_SPEED * 10, 0);
			velocity.rotate(FlxPoint.weak(0,0), tAngle);
		}
	}
}
