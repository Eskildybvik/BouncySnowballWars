import flixel.tile.FlxTilemap;
import flixel.FlxG;

class TileManager{
    private static inline var snowChance:Float = 0.1;
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
        var leftDirtOpen:Array<Int> = addArray(leftDirt);
        var rightDirtOpen:Array<Int> = addArray(rightDirt);
        var leftIceOpen:Array<Int> = addArray(leftIce);
        var rightIceOpen:Array<Int> = addArray(rightIce);

        for(index in leftDirtOpen){
            if(FlxG.random.bool(snowChance)){
                leftDirt.setTileByIndex(index, leftDirt.getData()[index]+1);
            }
        }
        for(index in leftIceOpen){
            if(FlxG.random.bool(snowChance)){
                leftIce.setTileByIndex(index, leftIce.getData()[index]+1);
            }
        }
        for(index in rightDirtOpen){
            if(FlxG.random.bool(snowChance)){
                rightDirt.setTileByIndex(index, rightDirt.getData()[index]+1);
            }
        }
        for(index in rightIceOpen){
            if(FlxG.random.bool(snowChance)){
                rightIce.setTileByIndex(index, rightIce.getData()[index]+1);
            }
        }
    }

    private function addArray(tileMap:FlxTilemap):Array<Int>{
        var arr:Array<Int> = [];
        for(i in 1...5){
            if(tileMap.getTileInstances(i) != null){
                arr = arr.concat(tileMap.getTileInstances(i));
            }
        }
        return arr;
    }




}