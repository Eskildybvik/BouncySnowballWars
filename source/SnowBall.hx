package;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import openfl.geom.Point;



class SnowBall extends FlxSprite {
	// Point - storing 2d vectors
	private var ballMovement:Point;
	private static inline var ballSpeed:Int = 100;
	// inline - når kode kompiled: bytter direkte ut ballSpedd -> Dermed ingen forsinkelser 

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(24, 24, FlxColor.BLUE);
		// DRAG - If you are using `acceleration`, you can use `maxVelocity` with it
	 	// to cap the speed automatically (very useful!).
		drag.set(ballSpeed*8, ballSpeed*8);
		maxVelocity.set(ballSpeed, ballSpeed);
		
		//ballMovement = new Point(0, 0);   // brukedette til å holde styr på posisjon?
		// collide function



	}


	override public function update(elapsed:Float) {
		controls();
		super.update(elapsed);

		// sjekke om den tocher 
		//isTouching
	}




	// midlertidlig
	// skal selvfølgelig ikke kunne styre ballen med taster
	private function controls() {
		var tUp = FlxG.keys.pressed.UP;
		var tLeft = FlxG.keys.pressed.LEFT;
		var tDown = FlxG.keys.pressed.DOWN;
		var tRight = FlxG.keys.pressed.RIGHT;

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
			velocity.set(ballSpeed * 10, 0);
			velocity.rotate(FlxPoint.weak(0,0), tAngle);
		}
	}
}
