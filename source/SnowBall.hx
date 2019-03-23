package;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;




class SnowBall extends FlxSprite {

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(24, 24, FlxColor.BLUE);
	}


	// sjekker hver frame
	override public function update(elapsed:Float) {
		if (isTouching(FlxObject.FLOOR)) {
			velocity.y = - velocity.y;
			velocity.x = -velocity.x;
		}
		if (isTouching(FlxObject.CEILING)) {
			velocity.y = -velocity.y;
		}
		if (isTouching(FlxObject.WALL)) {
			velocity.x = -velocity.x;
		}

	super.update(elapsed);

	}
}
