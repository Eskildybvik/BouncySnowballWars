package;

import powerups.Powerup;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
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
	private static inline var POWERUP_SPAWN_CHANCE = 0.1;
	private var snowMapLeft:FlxTilemap;
	private var snowMapRight:FlxTilemap;
	private var leftPlayerHighlightBox:FlxSprite;
	private var rightPlayerHighlightBox:FlxSprite;

	private var obstacles:FlxTypedSpriteGroup<Obstacle>;
	private var powerupGroup:FlxTypedSpriteGroup<powerups.Powerup>;

	private var walls:FlxTilemap;
	private var midline:FlxSprite;

	private var leftPlayer:Player;
	private var rightPlayer:Player;

	public var allSnowballs:FlxTypedGroup<FlxTypedSpriteGroup<SnowBall>>;
	
	//For controlls
	public var leftInput:FlxGamepad = null;
	public var rightInput:FlxGamepad = null;

	//For tiles
	private var tileManager:TileManager;
	

	override public function create():Void {	
		super.create();

		walls = new FlxTilemap();
		var tempArray = []; 
		tempArray.push([for (i in 0...22) 1]);
		for (i in 0...11) {
			var tempTempArray = [for (j in 0...20) 0];
			tempTempArray.push(1);
			tempTempArray.unshift(1);
			tempArray.push(tempTempArray);
		}
		tempArray.push([for (i in 0...22) 1]);
		walls.loadMapFrom2DArray(tempArray, "assets/images/ice_wall.png", 64, 64, null, 0, 1, 1);
		add(walls);

		tileManager = new TileManager(this);

		midline = new FlxSprite(0, 0);
		// midline.makeGraphic(8, FlxG.height, FlxColor.RED);
		midline.loadGraphic("assets/images/Rope.png", false);
		midline.screenCenter();
		add(midline);
		midline.immovable = true;

		leftPlayer = new Player(128, 128, false);
		leftPlayer.gamepad = leftInput;
		add(leftPlayer.snowballs);
		add(leftPlayer);

		rightPlayer = new Player(FlxG.width - 192, 128, true);
		rightPlayer.gamepad = rightInput;
		// Comment out these two lines to disable player 2
		add(rightPlayer.snowballs);
		add(rightPlayer);


		obstacles = new FlxTypedSpriteGroup<Obstacle>(0, 0);
		add(obstacles);
		powerupGroup = new FlxTypedSpriteGroup<powerups.Powerup>(0, 0);
		add(powerupGroup);

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

		var snowParticles = new FlxBackdrop("assets/images/Near Snow.png", 1, 1, true, true);
		FlxTween.tween(snowParticles, {x: FlxG.width, y:FlxG.height * 5}, 30, {type: FlxTweenType.LOOPING, ease: flixel.tweens.FlxEase.sineInOut});
		add(snowParticles);

		add(new HUD());

		FlxG.sound.playMusic("assets/music/RIP.ogg", 0.5, true);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		tileManager.addSnow();

		FlxG.collide(leftPlayer, walls);
		FlxG.collide(leftPlayer, midline);
		FlxG.collide(leftPlayer, obstacles);

		FlxG.collide(rightPlayer, walls);
		FlxG.collide(rightPlayer, midline);
		FlxG.collide(rightPlayer, obstacles);

		FlxG.overlap(allSnowballs, walls, FlxObject.updateTouchingFlags);

		FlxG.overlap(allSnowballs, obstacles, function(s:SnowBall, o:Obstacle) {
			if (!o.inUse) return;
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
		FlxG.overlap(allSnowballs, allSnowballs, function(s1:SnowBall, s2:SnowBall) {
			if (!s1.inUse || !s2.inUse) return; // Avoids killing dead snowballs
			s1.kill();
			s2.kill();
		});

		// obstacle placement
		leftPlayerHighlightBox.x = Math.ceil((leftPlayer.x)/tileWidth + 0.5) * 64;
		leftPlayerHighlightBox.y = Math.round(leftPlayer.y/tileHeight) * 64;
		
		// Checks if player has pressed the build button, and builds on his side of them map
		if (leftPlayer.building && leftPlayerHighlightBox.x+16 < midline.x) {
			var temp = new Obstacle(leftPlayerHighlightBox.x, leftPlayerHighlightBox.y);
			obstacles.add(temp);
			obstacles.sort(FlxSort.byY);
		}

		rightPlayerHighlightBox.x = Math.floor((rightPlayer.x)/tileWidth - 0.5) * 64;
		rightPlayerHighlightBox.y = Math.round(rightPlayer.y/tileHeight) * 64;
		
		if (rightPlayer.building && rightPlayerHighlightBox.x > midline.x) {
			var temp = new Obstacle(rightPlayerHighlightBox.x, rightPlayerHighlightBox.y);
			obstacles.add(temp);
			obstacles.sort(FlxSort.byY);
		}

		//picking up snow

		if (rightPlayer.pickUpSnow){
			tileManager.getSnow(rightPlayer);
		}
		if (leftPlayer.pickUpSnow){
			tileManager.getSnow(leftPlayer);
		}

		//adjusting drag based on ice
		if(tileManager.isOnIce(rightPlayer)){
			rightPlayer.drag.set(0, 0);
		}else{
			rightPlayer.drag.set(4000, 4000);
		}
		if(tileManager.isOnIce(leftPlayer)){
			leftPlayer.drag.set(0, 0);
		}else{
			leftPlayer.drag.set(4000, 4000);
		}

		// Maybe generates powerups
		if (FlxG.random.bool(POWERUP_SPAWN_CHANCE)) {
			// Places a random powerup at a random location of the map.
			var pX = FlxG.random.int(tileWidth, FlxG.width-tileWidth*2);
			var pY = FlxG.random.int(tileHeight, FlxG.height - tileHeight*2);
			powerupGroup.add(Powerup.getRandomPowerup(pX, pY));
		}
		FlxG.overlap(leftPlayer, powerupGroup, function(pl:Player, pu:Powerup) {
			if (pu.collected) return;
			pu.collect(pl);
		});
		FlxG.overlap(rightPlayer, powerupGroup, function(pl:Player, pu:Powerup) {
			if (pu.collected) return;
			pu.collect(pl);
		});
		
	}	
}
