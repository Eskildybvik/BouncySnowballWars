package powerups;

class Get10Snow extends Powerup {
	public function new(x:Float, y:Float) {
		super(x, y);
		animation.add("show", [5], 1, false);
		animation.play("show");
		timeBased = false;
	}

	override public function collect(player:Player) {
		if (player.isRightPlayer) Reg.rightPlayerSnow += 10;
		else Reg.leftPlayerSnow += 10;
		super.collect(player);
	}
}