package com.cocosw.cardgame.uiview;
import com.haxepunk.Entity;

import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import nme.events.MouseEvent;

/**
 * ...
 * @author soar
 */

 //对点击事件做了封装
 
class View extends Entity
{

	
    // sets velocity based on keyboard input
    public override function update()
    {
		super.update();
		if (collidePoint(x, y, Input.mouseX, Input.mouseY)) {
			if (Input.mouseReleased)
			{
				clicked(this);
			}
			else if (Input.mouseDown)
			{
				mouseDown();
			}
			else
			{
				mouseOver();
			}
		}
    }
	
	// click简单
	public function clicked(view:View):Void {
	}
	
	// 按下事件
	public function mouseDown():Void{
	}
	
	// over事件
	public function mouseOver():Void{
	}
}