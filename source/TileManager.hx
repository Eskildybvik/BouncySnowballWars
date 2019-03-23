import flixel.tile.FlxTilemap;
import flixel.FlxG;

class TileManager{
    private static inline var snowChance:Float = 0.01;
    public var leftDirt:FlxTilemap = new FlxTilemap();
    public var rightDirt:FlxTilemap = new FlxTilemap();
    public var leftIce:FlxTilemap = new FlxTilemap();
    public var rightIce:FlxTilemap = new FlxTilemap();
    public var obstacleMapLeftData:Array<Array<Int>> = [
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0]];

    private var wallThickness:Int = 7;
	private var xOffset:Int = 58;


    public function new(parent:PlayState) {

        leftDirt.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/DirtTiles.png", 64, 64, null, 0, 1, 6);
        leftIce.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/IceTiles.png", 64, 64, null, 0, 1, 6);
        rightDirt.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/DirtTiles.png", 64, 64, null, 0, 1, 6);
        rightIce.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/IceTiles.png", 64, 64, null, 0, 1, 6);

        leftDirt.setPosition(xOffset, wallThickness + 1);
        leftIce.setPosition(xOffset, wallThickness + 1);
        rightDirt.setPosition(wallThickness * 2 + 64 * 9 + 54, wallThickness + 1);
        rightIce.setPosition(wallThickness * 2 + 64 * 9 + 54, wallThickness + 1);

        for (i in 0...10) {
            for (j in 0...11) {
                if(FlxG.random.bool()) {
                    leftIce.setTile(i, j, 1);
                    rightIce.setTile(9-i, j, 1);
                }
                else {
                    leftDirt.setTile(i, j, 1);
                    rightDirt.setTile(9-i, j, 1);
                }
            }
        }

        parent.add(leftDirt);
        parent.add(leftIce);
        parent.add(rightDirt);
        parent.add(rightIce);
    }

    public function addSnow() {
        
    }
}