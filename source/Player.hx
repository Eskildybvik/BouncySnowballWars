package;

import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;

class Player extends FlxSprite {
	private static inline var PLAYER_SPEED:Int = 500;
	private static inline var SNOWBALL_SPEED:Int = 1000;
	public var snowballs:FlxTypedSpriteGroup<SnowBall>;
	public var gamepad:FlxGamepad = null;
	public var building:Bool = false;
	private var throwCooldown:Int = 0;

	public function new(x:Float, y:Float) {
		super(x, y);

		// makeGraphic(64, 64, FlxColor.CYAN);
		// loadGraphic(AssetPaths.player__png, true, 64, 64);
		loadGraphic(AssetPaths.playerwalkthrow__png, true, 64, 64);
		// Uncomment to ease implementation directional animation
		// animation.add("walk_left", [0, 4, 8, 12], 12, true);
		// animation.add("walk_up", [1, 5, 9, 13], 12, true);
		// animation.add("walk_down", [2, 6, 10, 14], 12, true);
		// animation.add("walk_right", [3, 7, 11, 15], 12, true);
		// animation.add("still_left", [16, 20, 24, 28], 12, true);
		// animation.add("still_up", [17, 21, 25, 29], 12, true);
		// animation.add("still_down", [18, 22, 26, 30], 12, true);
		// animation.add("still_right", [19, 23, 27, 31], 12, true);
		// animation.add("walk", [3, 7, 11, 15], 8, true);
		// animation.add("still", [19, 23, 27, 31], 8, true);
		animation.add("walk", [0, 3, 6, 9], 8, true);
		animation.add("still", [0], 1, false);
		animation.add("walk_throw", [0, 5, 11], 8, false);
		animation.add("still_throw", [0, 1, 2], 8, false);
		animation.play("still");
		setSize(46, 62);
		offset.set(11, 1);

		drag.set(PLAYER_SPEED*8, PLAYER_SPEED*8);
		// gamepad = FlxG.gamepads.firstActive; // Set manually for multple players
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
		animate();
		throwCooldown--;
		super.update(elapsed);
	}

	private function controls() {
		if (gamepad == null) {
			keyboardMovement();
			if (FlxG.mouse.justPressed) {
				mouseShoot();
			}
			building = FlxG.mouse.justPressedRight;
		}
		else {
			gamepadMovement();
			if (gamepad.justPressed.RIGHT_SHOULDER) {
				gamepadShoot();
			}
			building = gamepad.justPressed.LEFT_SHOULDER;
		}
	}

	private function animate() {
		if (throwCooldown < 10) {
			animation.play(velocity.x+velocity.y == 0 ? "still" : "walk");
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
		if (throwCooldown > 0) return;
		throwCooldown = 20;
		// Calculates the shooting angle based on the mouse
		var tAngle = Math.atan2(FlxG.mouse.y - y-height/2, FlxG.mouse.x - x-width/2) * 57.29578;
		var snowball = snowballs.recycle();
		snowball.reset(x+width/2, y+height/2); // sets snowball starting point
		snowball.velocity.set(SNOWBALL_SPEED, 0);
		snowball.velocity.rotate(FlxPoint.weak(0,0), tAngle);
		animation.play(animation.name + "_throw");
	}

	private function gamepadMovement() {
		var leftStickVector = gamepad.getAnalogAxes(FlxGamepadInputID.LEFT_ANALOG_STICK);
		if (leftStickVector.x != 0 || leftStickVector.y != 0) {
			var velocityMultiplier = leftStickVector.length > 0.75 ? 1 : leftStickVector.length;
			velocity.set(PLAYER_SPEED * velocityMultiplier, 0);
			velocity.rotate(FlxPoint.weak(0, 0), leftStickVector.degrees);
		}
	}

	private function gamepadShoot() {
		if (throwCooldown > 0) return;
		throwCooldown = 20;
		var rightStickVector = gamepad.getAnalogAxes(FlxGamepadInputID.RIGHT_ANALOG_STICK);
		if (rightStickVector.x != 0 || rightStickVector.y != 0) { // A direction is required to shoot
			var snowball = snowballs.recycle();
			snowball.reset(x+width/2, y+height/2);
			snowball.velocity.set(SNOWBALL_SPEED, 0);
			snowball.velocity.rotate(FlxPoint.weak(0, 0), rightStickVector.degrees);
			animation.play(animation.name + "_throw");
		}
	}
}
