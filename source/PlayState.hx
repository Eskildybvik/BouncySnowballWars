package;

import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.id.LogitechID;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
	// for obstacles and snow tiles
	static inline var tileWidth:Int = 64;
	static inline var tileHeight:Int = 64;
	private var obstacleMap:FlxTilemap;
	private var snowMap:FlxTilemap;
	private var leftPlayerHighlightBox:FlxSprite;
	private var obstacleMapData:Array<Array<Int>> = [
	[0,0,0,0,1,0,0,0,0,-9,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,-9,0,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,-9,0,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,-9,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,1,0,-9,0,1,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,1,0,-9,0,1,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,1,0,-9,0,1,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,-9,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,-9,0,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,-9,0,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0,-9,0,0,0,0,0,0,0,0,0,1]];	

	private var wallThickness:Int = 7;
	private var xOffset:Int = 32;
	private var midline:FlxSprite;
	private var tempWalls:FlxSpriteGroup;
	private var leftPlayer:Player;

	override public function create():Void {	
		super.create();

		midline = new FlxSprite(0, 0);
		midline.makeGraphic(8, FlxG.height, FlxColor.RED);
		midline.screenCenter(X);
		add(midline);
		midline.immovable = true;

		leftPlayer = new Player(128, 128);
		add(leftPlayer.snowballs);
		add(leftPlayer);

		// temp walls
		tempWalls = new FlxSpriteGroup(0, 0);
		var topWall = new FlxSprite(0, 0);
		topWall.makeGraphic(FlxG.width, wallThickness + 1, FlxColor.GREEN);
		tempWalls.add(topWall);
		var leftWall = new FlxSprite(0, wallThickness);
		leftWall.makeGraphic(wallThickness, FlxG.height - (wallThickness * 2), FlxColor.GREEN);
		tempWalls.add(leftWall);
		var bottomWall = new FlxSprite(0, FlxG.height - wallThickness);
		bottomWall.makeGraphic(FlxG.width, wallThickness, FlxColor.GREEN);
		tempWalls.add(bottomWall);
		var rightWall = new FlxSprite(FlxG.width - wallThickness, wallThickness);
		rightWall.makeGraphic((wallThickness * 2), FlxG.height - (wallThickness * 2), FlxColor.GREEN);
		tempWalls.add(rightWall);
		add(tempWalls);
		tempWalls.immovable = true;

		// tilemap stuff begins here
		obstacleMap = new FlxTilemap();

		obstacleMap.loadMapFrom2DArray(obstacleMapData, "assets/images/white.jpg", 64, 64, null, 0, 1, 1);
		obstacleMap.setPosition(xOffset, wallThickness + 1);
		add(obstacleMap);

		leftPlayerHighlightBox = new FlxSprite(0, 0);
		leftPlayerHighlightBox.makeGraphic(tileWidth, tileHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(leftPlayerHighlightBox, 0, 0, tileWidth, tileHeight, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(leftPlayerHighlightBox);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FlxG.collide(leftPlayer, tempWalls);
		FlxG.collide(leftPlayer, midline);
		FlxG.collide(leftPlayer.snowballs, tempWalls);

		FlxG.collide(leftPlayer.snowballs, leftPlayer); // må fikse logikk, slik at ballen stopper i spiller 

		FlxG.collide(leftPlayer, obstacleMap);

		// obstacle placement
		leftPlayerHighlightBox.x = Math.ceil((leftPlayer.x - xOffset)/tileWidth + 1) * tileWidth + xOffset;
		leftPlayerHighlightBox.y = Math.round(leftPlayer.y/tileHeight) * tileHeight + wallThickness;
		
		if (FlxG.keys.pressed.B) {
			obstacleMap.setTile(Math.ceil((leftPlayer.x - xOffset)/tileWidth) + 1, Math.round(leftPlayer.y/tileHeight), 1);
		}
	}
}
