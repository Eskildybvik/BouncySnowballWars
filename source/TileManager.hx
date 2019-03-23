import flixel.tile.FlxTilemap;
import flixel.FlxG;

class TileManager{
    private static inline var snowChance:Float = 0.3;
    public var leftDirt:FlxTilemap = new FlxTilemap();
    public var rightDirt:FlxTilemap = new FlxTilemap();
    public var leftIce:FlxTilemap = new FlxTilemap();
    public var rightIce:FlxTilemap = new FlxTilemap();
    public var obstacleMapLeftData:Array<Array<Int>> = [
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]];

    private var wallThickness:Int = 64;


    public function new(parent:PlayState){

        leftDirt.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/DirtTiles.png", 64, 64, null, 0, 1, 6);
        leftIce.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/IceTiles.png", 64, 64, null, 0, 1, 6);
        rightDirt.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/DirtTiles.png", 64, 64, null, 0, 1, 6);
        rightIce.loadMapFrom2DArray(obstacleMapLeftData, "assets/images/IceTiles.png", 64, 64, null, 0, 1, 6);

        leftDirt.setPosition(wallThickness, wallThickness);
        leftIce.setPosition(wallThickness, wallThickness);
        rightDirt.setPosition(wallThickness*11, wallThickness);
        rightIce.setPosition(wallThickness*11, wallThickness);

        for(i in 0...10){
            for(j in 0...11){
                if(FlxG.random.bool()){
                    leftIce.setTile(i, j, 1);
                    rightIce.setTile(9-i, j, 1);
                }else{
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

    public function addSnow(){
        var leftDirtOpen:Array<Int> = leftDirt.getTileInstances(1).concat(leftDirt.getTileInstances(2).concat(leftDirt.getTileInstances(3).concat(leftDirt.getTileInstances(4))));
        var rightDirtOpen:Array<Int> = rightDirt.getTileInstances(1).concat(rightDirt.getTileInstances(2).concat(rightDirt.getTileInstances(3).concat(rightDirt.getTileInstances(4))));
        var leftIceOpen:Array<Int> = leftIce.getTileInstances(1).concat(leftIce.getTileInstances(2).concat(leftIce.getTileInstances(3).concat(leftIce.getTileInstances(4))));
        var rightIceOpen:Array<Int> = rightIce.getTileInstances(1).concat(rightIce.getTileInstances(2).concat(rightIce.getTileInstances(3).concat(rightIce.getTileInstances(4))));
        
        var numOpen:Int = leftDirtOpen.length + rightDirtOpen.length + leftIceOpen.length + rightIceOpen.length;

        for(index in leftDirtOpen){
            if(FlxG.random.bool(snowChance)){
                leftDirt.setTileByIndex(index, 5);
            }
        }
    }




}