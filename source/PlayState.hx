package;

import flixel.util.FlxSort;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
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
	private var snowMapLeft:FlxTilemap;
	private var snowMapRight:FlxTilemap;
	private var leftPlayerHighlightBox:FlxSprite;
	private var rightPlayerHighlightBox:FlxSprite;

	private var obstacles:FlxTypedSpriteGroup<Obstacle>;

	private var wallThickness:Int = 7;
	private var xOffset:Int = 58;
	private var midline:FlxSprite;
	private var walls:FlxSpriteGroup;
	private var leftPlayer:Player;
	private var rightPlayer:Player;

	public var allSnowballs:FlxTypedGroup<FlxTypedSpriteGroup<SnowBall>>;
	public var tileHandler:Tiles;
	
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

		walls = new FlxSpriteGroup(0, 0);
		var topWall = new FlxSprite(0, 0);
		topWall.makeGraphic(FlxG.width, wallThickness + 1, FlxColor.GREEN);
		walls.add(topWall);
		var leftWall = new FlxSprite(0, wallThickness);
		leftWall.makeGraphic(wallThickness, FlxG.height - (wallThickness * 2), FlxColor.GREEN);
		walls.add(leftWall);
		var bottomWall = new FlxSprite(0, FlxG.height - wallThickness);
		bottomWall.makeGraphic(FlxG.width, wallThickness, FlxColor.GREEN);
		walls.add(bottomWall);
		var rightWall = new FlxSprite(FlxG.width - wallThickness, wallThickness);
		rightWall.makeGraphic((wallThickness * 2), FlxG.height - (wallThickness * 2), FlxColor.GREEN);
		walls.add(rightWall);
		add(walls);
		walls.immovable = true;

		obstacles = new FlxTypedSpriteGroup<Obstacle>(0, 0);
		add(obstacles);

		leftPlayerHighlightBox = new FlxSprite(0, 0);
		leftPlayerHighlightBox.makeGraphic(tileWidth, tileHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(leftPlayerHighlightBox, 0, 0, tileWidth, tileHeight, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(leftPlayerHighlightBox);

		rightPlayerHighlightBox = new FlxSprite(0, 0);
		rightPlayerHighlightBox.makeGraphic(tileWidth, tileHeight, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(rightPlayerHighlightBox, 0, 0, tileWidth, tileHeight, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(rightPlayerHighlightBox);

		// snowballs
		allSnowballs = new FlxTypedGroup<FlxTypedSpriteGroup<SnowBall>>();
		allSnowballs.add(leftPlayer.snowballs);
		allSnowballs.add(rightPlayer.snowballs);

		tileHandler = new Tiles();

		add(new HUD());
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(leftPlayer, walls);
		FlxG.collide(leftPlayer, midline);
		FlxG.collide(leftPlayer, obstacles);

		FlxG.collide(rightPlayer, walls);
		FlxG.collide(rightPlayer, midline);
		FlxG.collide(rightPlayer, obstacles);

		FlxG.overlap(allSnowballs, walls, FlxObject.updateTouchingFlags);

		FlxG.overlap(allSnowballs, obstacles, function(s:SnowBall, o:Obstacle) {
			FlxObject.updateTouchingFlags(s, o);
			o.damage();
		});

		FlxG.overlap(leftPlayer, allSnowballs, function(p:Player, s:SnowBall) {
			if (!s.inUse) return; // Prevents player from taking damage from particles
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

		// Delete snowballs when they collide with each other
		FlxG.collide(allSnowballs, allSnowballs, function(s1:SnowBall, s2:SnowBall) {
			if (!s1.inUse || !s2.inUse) return; // Avoids killing dead snowballs
			s1.kill();
			s2.kill();
		});

		// obstacle placement
		leftPlayerHighlightBox.x = Math.ceil((leftPlayer.x)/tileWidth - 0.5) * tileWidth + xOffset;
		leftPlayerHighlightBox.y = Math.round(leftPlayer.y/tileHeight) * tileHeight + wallThickness + 1;
		
		// Checks if player has pressed the build button, and builds on his side of them map
		if (leftPlayer.building && leftPlayerHighlightBox.x+16 < midline.x) {
			var temp = new Obstacle(leftPlayerHighlightBox.x, leftPlayerHighlightBox.y);
			obstacles.add(temp);
			obstacles.sort(FlxSort.byY);
		}

		rightPlayerHighlightBox.x = Math.floor((rightPlayer.x)/tileWidth - 0.5) * tileWidth + 5;
		rightPlayerHighlightBox.y = Math.round(rightPlayer.y/tileHeight) * tileHeight + wallThickness + 1;
		
		if (rightPlayer.building && rightPlayerHighlightBox.x > midline.x) {
			var temp = new Obstacle(rightPlayerHighlightBox.x, rightPlayerHighlightBox.y);
			obstacles.add(temp);
			obstacles.sort(FlxSort.byY);
		}
	}	
}
