package;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;

class MenuState extends FlxState {
    private var leftInput:FlxGamepad;
    private var rightInput:FlxGamepad;
    private var prompt:FlxText;
    private var findingLeft:Bool = true;
    private var foundLeft:Bool = true;
    private var foundRight:Bool = true;
    private var game:PlayState;

    override public function create():Void {
        super.create();

        //Sets up text
        prompt = new FlxText();
        prompt.text = "Player 1 press any button";
        prompt.size = 24;
        prompt.screenCenter();
        add(prompt);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        //Checks for input for left player
        if(findingLeft){
            if(FlxG.gamepads.anyInput()){
                findingLeft = false;
                leftInput = FlxG.gamepads.lastActive;
                prompt.text = "Player 2 press any button";
            }else if(FlxG.keys.firstJustPressed() != -1){
                findingLeft = false;
                leftInput = null;
                prompt.text = "Player 2 press any button";
            }
        }else{ //Checks for inputs for right player
            if(FlxG.gamepads.anyInput() && leftInput != FlxG.gamepads.lastActive){
                rightInput = FlxG.gamepads.lastActive;
                startGame();
            }else if(FlxG.keys.firstJustPressed() != -1 && leftInput != null){
                rightInput = null;
                startGame();
            }
        }

    }

    private function startGame():Void{
        game = new PlayState();
        FlxG.switchState(game);
    }

}