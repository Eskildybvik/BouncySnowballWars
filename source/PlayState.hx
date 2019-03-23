package;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.id.LogitechID;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSpriteUtil;
import flixel.input.gamepad.FlxGamepad;

class PlayState extends FlxState {
	// for obstacles and snow tiles
	static inline var tileWidth:Int = 64;
	static inline var tileHeight:Int = 64;
	private var obstacleMapLeft:FlxTilemap;
	private var obstacleMapRight:FlxTilemap;
	private var snowMapLeft:FlxTilemap;
	private var snowMapRight:FlxTilemap;
	private var leftPlayerHighlightBox:FlxSprite;
	private var rightPlayerHighlightBox:FlxSprite;
	private var obstacleMapLeftData:Array<Array<Int>> = [
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,1,0],
	[0,0,0,0,0,0,0,1,0],
	[0,0,0,0,0,0,0,1,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0]];	

	private var obstacleMapRightData:Array<Array<Int>> = [
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,0,0],
	[0,1,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,0,0]];

	private var wallThickness:Int = 7;
	private var xOffset:Int = 58;
	private var midline:FlxSprite;
	private var tempWalls:FlxSpriteGroup;
	private var leftPlayer:Player;
	private var rightPlayer:Player;

	private var allSnowballs:FlxTypedGroup<FlxTypedSpriteGroup<SnowBall>>;
	
	//For controlls
	public var leftInput:FlxGamepad = null;
	public var rightInput:FlxGamepad = null;
	

	override public function create():Void {	
		super.create();

		midline = new FlxSprite(0, 0);
		midline.makeGraphic(8, FlxG.height, FlxColor.RED);
		midline.screenCenter(X);
		add(midline);
		midline.immovable = true;

		leftPlayer = new Player(128, 128);
		leftPlayer.gamepad = leftInput;
		add(leftPlayer.snowballs);
		add(leftPlayer);

		rightPlayer = new Player(FlxG.width - 192, 128);
		rightPlayer.gamepad = rightInput;
		rightPlayer.flipX = true;
		// Comment out these two lines to disable player 2
		add(rightPlayer.snowballs);
		add(rightPlayer);

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
		obstacleMapLeft = new FlxTilemap();

		obstacleMapLeft.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/white.jpg", 64, 64, null, 0, 1, 1);
		obstacleMapLeft.setPosition(xOffset, wallThickness + 1);
		add(obstacleMapLeft);

		obstacleMapRight = new FlxTilemap();

		obstacleMapRight.loadMapFrom2DArray(obstacleMapRightData, "assets/images/white.jpg", 64, 64, null, 0, 1, 1);
		obstacleMapRight.setPosition(xOffset * 2 + 64 * 9, wallThickness + 1);
		add(obstacleMapRight);

		leftPlayerHighlightBox = new FlxSprite(0, 0);
		leftPlayerHighlightBox.makeGraphic(tileWidth, tileHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(leftPlayerHighlightBox, 0, 0, tileWidth, tileHeight, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(leftPlayerHighlightBox);

		// snowballs
		allSnowballs = new FlxTypedGroup<FlxTypedSpriteGroup<SnowBall>>();
		allSnowballs.add(leftPlayer.snowballs);
		allSnowballs.add(rightPlayer.snowballs);

		add(new HUD());
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(leftPlayer, tempWalls);
		FlxG.collide(leftPlayer, midline);
		FlxG.collide(leftPlayer, obstacleMapLeft);

		FlxG.collide(rightPlayer, tempWalls);
		FlxG.collide(rightPlayer, midline);
		FlxG.collide(rightPlayer, obstacleMapRight);

		FlxG.overlap(allSnowballs, obstacleMapLeft, FlxObject.updateTouchingFlags);
		FlxG.overlap(allSnowballs, obstacleMapRight, FlxObject.updateTouchingFlags);
		FlxG.overlap(allSnowballs, tempWalls, FlxObject.updateTouchingFlags);

		FlxG.overlap(leftPlayer, allSnowballs, function(p:Player, s:SnowBall) {
			if (!s.inUse) return;
			Reg.leftPlayerHearts--;
			s.kill();
			if (Reg.leftPlayerHearts == 0) {
				FlxG.switchState(new GameOverState());
			}
		});

		FlxG.overlap(rightPlayer, allSnowballs, function(p:Player, s:SnowBall) {
			if (!s.inUse) return;
			Reg.rightPlayerHearts--;
			s.kill();
			if (Reg.rightPlayerHearts == 0) {
				FlxG.switchState(new GameOverState());
			}
		});

		// obstacle placement
		leftPlayerHighlightBox.x = Math.ceil((leftPlayer.x)/tileWidth - 0.5) * tileWidth + xOffset;
		leftPlayerHighlightBox.y = Math.round(leftPlayer.y/tileHeight) * tileHeight + wallThickness;
		
		if (leftPlayer.building) {
			obstacleMapLeft.setTile(Math.ceil((leftPlayer.x)/tileWidth - 0.5), Math.round(leftPlayer.y/tileHeight), 1);
		}
	}
}
