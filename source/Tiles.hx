package;

import flixel.tile.FlxTile;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;

class Tiles extends FlxTilemap {
    private var obstacleMap:Array<Array<Int>>;
    private var snowMap:Array<Array<Int>>;

    public function leftTileHit(ball:SnowBall, thisTile:FlxTile) {
		//PlayState.obstacleMapLeft.getTile(thisTile.x, thisTile.y);
    	//PlayState.obstacleMapLeft.setTileByIndex(thisTile, 0, true);
    }   

	public function rightTileHit(ball:SnowBall, thisTile:FlxTile) {
        //PlayState.obstacleMapRight.setTileByIndex(thisTile, 0, FlxTile);
	} 
}