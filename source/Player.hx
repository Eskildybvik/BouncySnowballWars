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
	public var isRightPlayer:Bool;

	public function new(x:Float, y:Float, right:Bool) {
		super(x, y);

		isRightPlayer = right; 
		flipX = right;

		if (!isRightPlayer) loadGraphic("assets/images/playerwalkthrow.png", true, 64, 64);
		else loadGraphic("assets/images/player2walkthrow.png", true, 64, 64);
		animation.add("walk", [0, 3, 6, 9], 8, true);
		animation.add("still", [0], 1, false);
		animation.add("walk_throw", [0, 5, 11], 24, false);
		animation.add("still_throw", [0, 1, 2], 24, false);
		animation.play("still");
		setSize(46, 62);
		offset.set(11, 1);

		drag.set(PLAYER_SPEED*8, PLAYER_SPEED*8);
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
		building = false;
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
			if (FlxG.mouse.justPressedRight) build();
		}
		else {
			gamepadMovement();
			if (gamepad.justPressed.RIGHT_SHOULDER) {
				gamepadShoot();
			}
			if (gamepad.justPressed.LEFT_SHOULDER) build();
		}
	}

	private function build() {
		// FlipX is used to determine if this is the right or left player
		if ((flipX && Reg.rightPlayerSnow <= 4) || (!flipX && Reg.leftPlayerSnow <= 4)) return;
		if (flipX) Reg.rightPlayerSnow -= 5;
		if (!flipX) Reg.leftPlayerSnow -= 5;
		building = true;
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

	// Finds an angle from the mouse, and uses the shoot() method
	private function mouseShoot() {
		// Calculates the shooting angle based on the mouse
		var tAngle = Math.atan2(FlxG.mouse.y - y-height/2, FlxG.mouse.x - x-width/2) * 57.29578;
		shoot(tAngle);
	}

	private function gamepadMovement() {
		var leftStickVector = gamepad.getAnalogAxes(FlxGamepadInputID.LEFT_ANALOG_STICK);
		if (leftStickVector.x != 0 || leftStickVector.y != 0) {
			var velocityMultiplier = leftStickVector.length > 0.75 ? 1 : leftStickVector.length;
			velocity.set(PLAYER_SPEED * velocityMultiplier, 0);
			velocity.rotate(FlxPoint.weak(0, 0), leftStickVector.degrees);
		}
	}

	// Gets an angle from the gamepad, and uses the shoot() method
	private function gamepadShoot() {
		var rightStickVector = gamepad.getAnalogAxes(FlxGamepadInputID.RIGHT_ANALOG_STICK);
		if (rightStickVector.x != 0 || rightStickVector.y != 0) { // A direction is required to shoot
			shoot(rightStickVector.degrees);
		}
	}

	// Performs the shooting itself
	private function shoot(angle:Float) {
		if (throwCooldown > 0) return;
		if ((flipX && Reg.rightPlayerSnow <= 0) || !flipX && Reg.leftPlayerSnow <= 0) return;
		if (flipX) Reg.rightPlayerSnow--;
		else Reg.leftPlayerSnow--;
		throwCooldown = 20;
		animation.play(animation.name + "_throw", true);
		FlxG.sound.playMusic("assets/sounds/sfx_throw.wav", 1, false);
		animation.finishCallback = function(s:String) {
			animation.finishCallback = null;
			var snowball = snowballs.recycle();
			snowball.reset(x+width/2, y+height/2);
			snowball.velocity.set(SNOWBALL_SPEED, 0);
			snowball.velocity.rotate(FlxPoint.weak(0, 0), angle);
		}
	}
}
