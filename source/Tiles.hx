package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;

class Tiles extends FlxTilemap {
    private var obstacleMap:Array<Array<Int>>;
    private var snowMap:Array<Array<Int>>;

    public function tileHit(FirstObject:SnowBall, SecondObject:Int) {
        SecondObject--;
    }   
}