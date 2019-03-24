package powerups;

import flixel.FlxSprite;

class Powerup extends FlxSprite {
	private var duration:Int;
	private var timeBased:Bool;
	public var collected:Bool;
	private var disappearAfterFrames:Int;

	public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic("assets/images/PowerUps.png", true, 32, 32); // All powerup sprites come from the same spritesheet
		duration = 600; // 10 seconds, override in other powerups
		timeBased = true; // If duration should be decreased every frame.
		collected = false;
		disappearAfterFrames = 450; // Exist for five seconds
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (timeBased) duration--;
		disappearAfterFrames--;
		if (disappearAfterFrames <= 0) destroy();
	}

	// Override to set 
	public function collect(collectingPlayer:Player) {
		visible = false;
		collected = true;
	}

	public static function getRandomPowerup(x:Float, y:Float):Powerup {
		return new Get10Snow(x, y);
	}
}