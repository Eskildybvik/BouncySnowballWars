package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	private static inline var PLAYER_SPEED:Int = 100;
	public var snowballs:FlxTypedSpriteGroup<SnowBall>;

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(64, 64, FlxColor.CYAN);
		drag.set(PLAYER_SPEED*8, PLAYER_SPEED*8);
		maxVelocity.set(PLAYER_SPEED, PLAYER_SPEED);

		// Created 8 snowballs to be recycled
		snowballs = new FlxTypedSpriteGroup<SnowBall>(0, 0, 8);
		for (i in 0...8) {
			var temp = new SnowBall(0, 0);
			temp.exists = false;
			snowballs.add(temp);
		}
	}

	override public function update(elapsed:Float) {
		controls();
		super.update(elapsed);
	}

	private function controls() {
		// Replace to implement different cotrol schemes.
		var tUp = FlxG.keys.pressed.W;
		var tLeft = FlxG.keys.pressed.A;
		var tDown = FlxG.keys.pressed.S;
		var tRight = FlxG.keys.pressed.D;
		var tShoot = FlxG.mouse.justPressed;

		var tAngle = 0;
		var tWillMove = false;

		// Calculates an angle, and sets velocity
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

		if (tShoot) shoot();
	}

	private function shoot() {
		var tAngle = Math.atan2(FlxG.mouse.y - y-height/2, FlxG.mouse.x - x-width/2) * 57.29578;
		var snowball = snowballs.recycle();
		snowball.reset(x+width/2, y+height/2); //sets bullet starting point
		snowball.velocity.set(500, 0);
		snowball.velocity.rotate(FlxPoint.weak(0,0), tAngle);
	}
}
