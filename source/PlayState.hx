package;

import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.id.LogitechID;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState {
	//For obstacles and snow tiles
	static inline var tileWidth:Int = 64;
	static inline var tileHeight:Int = 64;
	var obstacleMap:FlxTilemap;
	var snowMap:FlxTilemap;
	var highlightBox:FlxSprite;

	private var midline:FlxSprite;
	private var tempWalls:FlxSpriteGroup;
	private var leftPlayer:Player;

	override public function create():Void {	
		super.create();

		midline = new FlxSprite(0, 0);
		midline.makeGraphic(8, FlxG.height, FlxColor.RED);
		midline.screenCenter(X);
		add(midline);

		leftPlayer = new Player(128, 128);
		add(leftPlayer);
		add(new SnowBall(156, 228));

		// temp walls
		tempWalls = new FlxSpriteGroup(0, 0);
		var topWall = new FlxSprite(0, 0);
		topWall.makeGraphic(FlxG.width, 32, FlxColor.GREEN);
		tempWalls.add(topWall);
		var leftWall = new FlxSprite(0, 32);
		leftWall.makeGraphic(32, FlxG.height - 64, FlxColor.GREEN);
		tempWalls.add(leftWall);
		var bottomWall = new FlxSprite(0, FlxG.height-32);
		bottomWall.makeGraphic(FlxG.width, 32, FlxColor.GREEN);
		tempWalls.add(bottomWall);
		var rightWall = new FlxSprite(FlxG.width - 32, 32);
		rightWall.makeGraphic(32, FlxG.height-64, FlxColor.GREEN);
		tempWalls.add(rightWall);
		add(tempWalls);
		tempWalls.immovable = true;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FlxG.collide(leftPlayer, tempWalls);
	}
}
