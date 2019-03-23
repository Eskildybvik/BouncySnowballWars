package;

import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite {
	private static inline var PLAYER_SPEED:Int = 500;
	private static inline var SNOWBALL_SPEED:Int = 1000;
	public var snowballs:FlxTypedSpriteGroup<SnowBall>;
	public var gamepad:FlxGamepad = null;

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(64, 64, FlxColor.CYAN);
		drag.set(PLAYER_SPEED*8, PLAYER_SPEED*8);
		gamepad = FlxG.gamepads.firstActive; // Set manually for multple players
		if (gamepad != null) {
			gamepad.deadZone = 0.3;
		}

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
		if (gamepad == null) {
			keyboardMovement();
			if (FlxG.mouse.justPressed) {
				mouseShoot();
			}
		}
		else {
			gamepadMovement();
			if (gamepad.justPressed.RIGHT_SHOULDER) {
				gamepadShoot();
			}
		}

	}

	private function keyboardMovement() {
		// Replace to implement different cotrol schemes.
		var tUp = FlxG.keys.pressed.W;
		var tLeft = FlxG.keys.pressed.A;
		var tDown = FlxG.keys.pressed.S;
		var tRight = FlxG.keys.pressed.D;

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
			velocity.set(PLAYER_SPEED, 0);
			velocity.rotate(FlxPoint.weak(0,0), tAngle);
		}
	}

	private function mouseShoot() {
		// Calculates the shooting angle based on the mouse
		var tAngle = Math.atan2(FlxG.mouse.y - y-height/2, FlxG.mouse.x - x-width/2) * 57.29578;
		var snowball = snowballs.recycle();
		snowball.reset(x+width/2, y+height/2); // sets snowball starting point
		snowball.velocity.set(SNOWBALL_SPEED, 0);
		snowball.velocity.rotate(FlxPoint.weak(0,0), tAngle);
	}

	private function gamepadMovement() {
		var leftStickVector = gamepad.getAnalogAxes(FlxGamepadInputID.LEFT_ANALOG_STICK);
		if (leftStickVector.x != 0 || leftStickVector.y != 0) {
			velocity.set(PLAYER_SPEED * leftStickVector.length, 0);
			velocity.rotate(FlxPoint.weak(0, 0), leftStickVector.degrees);
		}
	}

	private function gamepadShoot() {
		var rightStickVector = gamepad.getAnalogAxes(FlxGamepadInputID.RIGHT_ANALOG_STICK);
		if (rightStickVector.x != 0 || rightStickVector.y != 0) { // A direction is required to shoot
			var snowball = snowballs.recycle();
			snowball.reset(x+width/2, y+height/2);
			snowball.velocity.set(SNOWBALL_SPEED, 0);
			snowball.velocity.rotate(FlxPoint.weak(0, 0), rightStickVector.degrees);
		}
	}
}
