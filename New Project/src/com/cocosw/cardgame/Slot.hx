package com.cocosw.cardgame;
import com.cocosw.cardgame.uiview.View;
import com.haxepunk.graphics.Image;
import nme.display.Bitmap;

/**
 * 棋盘的空槽 3*3 组成了棋盘
 * @author soar
 */

typedef SlotCallback = Slot -> Void;

class Slot extends View
{

	public var id:Int;
	public var empty:Bool;
	var bg:Image;
	var cb:SlotCallback;
	
    public function new(x:Float, y:Float, id:Int,cb:SlotCallback)
    {
        super(x, y);
		this.id = id;
		type = "Slot";
		bg = new Image("gfx/back.png");
		graphic = bg;
		empty = true;
		this.cb = cb;
		setHitbox(bg.width,bg.height);
	}	
	
	//向空位中放置卡片
	public function addCard(card:Card):Void {
		if (empty) {
			this.world.add(card);
			card.moveTo(x, y);
			empty = false;
		}
	}
	
	public override function clicked(view:View) {
		if (empty) {
			if (cb!=null)
			cb(this);
		}
	}
	
	
	public override function update()
    { 
        super.update();
    }
}