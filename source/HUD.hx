package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;

using StringTools;

class HUD extends FlxSpriteGroup {
	private static inline var OFFSET = 20; // Controls where the HUD is located relative to screen edges
	
	private var leftPlayerSnow:FlxText;
	private var leftPlayerHearts:FlxTypedSpriteGroup<Heart>;
	private var leftLastRegisteredHealth:Int = 5;

	private var rightPlayerSnow:FlxText;
	private var rightPlayerHearts:FlxTypedSpriteGroup<Heart>;
	private var rightLastRegisteredHealth:Int = 5;

	public function new() {
		super(0, 0);

		// The text does not need to display the right amount of snow, as it's set every frame in update
		leftPlayerSnow = new FlxText(OFFSET, OFFSET, 0, "Snow: 030", 32);
		add(leftPlayerSnow);
		rightPlayerSnow = new FlxText(OFFSET, OFFSET, 0, "Snow: 030", 32);
		rightPlayerSnow.x = FlxG.width - OFFSET - rightPlayerSnow.width; // Moves to the left side of the screen
		add(rightPlayerSnow);

		// Initialize health bars
		leftPlayerHearts = new FlxTypedSpriteGroup<Heart>(0, 0);
		rightPlayerHearts = new FlxTypedSpriteGroup<Heart>(0, 0);
		for (i in 0...5) {
			var tempLeft = new Heart(OFFSET + i*32, OFFSET + 32);
			leftPlayerHearts.add(tempLeft);
			var tempRight = new Heart(FlxG.width - OFFSET - (5-i)*32, OFFSET + 32);
			rightPlayerHearts.add(tempRight);
		}
		add(leftPlayerHearts);
		add(rightPlayerHearts);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		// Replaces text with a text representation of snow amount, and pads with zeroes.
		leftPlayerSnow.text = "Snow: " + (""+Reg.leftPlayerSnow).lpad("0", 3);
		rightPlayerSnow.text = "Snow: " + (""+Reg.rightPlayerSnow).lpad("0", 3);
		
		if (Reg.leftPlayerHearts < leftLastRegisteredHealth) {
			leftLastRegisteredHealth--;
			leftPlayerHearts.getFirstAlive().clear();
		}

		if (Reg.rightPlayerHearts < rightLastRegisteredHealth) {
			rightLastRegisteredHealth--;
			rightPlayerHearts.getFirstAlive().clear();
		}
	}
}

