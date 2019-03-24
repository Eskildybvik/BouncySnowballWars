package;

import flixel.FlxG;
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
                leftInput = FlxG.gamepads.getFirstActiveGamepad();
                prompt.text = "Player 2 press any button";
            }else if(FlxG.keys.firstJustPressed() != -1){
                findingLeft = false;
                leftInput = null;
                prompt.text = "Player 2 press any button";
            }
        }else{ //Checks for inputs for right player
            trace(FlxG.gamepads.lastActive);
            if(FlxG.gamepads.anyInput() && FlxG.gamepads.getFirstActiveGamepad() != leftInput){
                rightInput = FlxG.gamepads.getFirstActiveGamepad();
                startGame();
            }else if(FlxG.keys.firstJustPressed() != -1 && leftInput != null){
                rightInput = null;
                startGame();
            }
        }

    }

    private function startGame():Void{
        game = new PlayState();
        game.leftInput = leftInput;
        game.rightInput = rightInput;
        FlxG.switchState(game);
    }

}