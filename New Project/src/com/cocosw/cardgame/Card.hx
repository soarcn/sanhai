package com.cocosw.cardgame;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.cocosw.cardgame.uiview.View;
import com.haxepunk.Tween;
 

/**
 * ...
 * @author soar
 */

typedef CardCallback = Card -> Void;

class Card extends View
{
	private var sprite:Image;
	
	private var element:String;
	private var level:Int;
	private var locked = false;
	private var selected = false; 
	private var hasMalus = false; 
	private var hasBonus = false;
	private var scaleX:Float;
	
	private var animTempColor:Int;
	//背景的状态
	public var backstate = true;
	//背景图
	private var background:Spritemap;
	
	static public inline var  CARDHIGHT:Int = 150;
	static public inline var CARDWIGHT:Int = 150;
	
	static private inline var PAINT_SIZE:Int = 20;
	static private  inline var PAINT_COLOR:Int = 0x000000;
	static private inline var SHADOW_COLOR:Int = 0xffffff;
	
	public var cb:CardCallback;
	public var cardvalue:CardValue;
	public var slot:Slot;
	public var hand:Hand;
	
	static private  inline  var X_OFFSET:Int = 80;
	
    public function new(x:Float, y:Float,value:CardValue=null, cbFunc:CardCallback = null, slot:Slot=null)
    {
        super(x, y);
		this.slot = slot;
        // create a new spritemap (image, frameWidth, frameHeight)
		type = "Card";
		background = new Spritemap("gfx/cardback.png",CARDHIGHT,CARDWIGHT);
        background.centerOrigin();
        background.add("front", [0]);
        background.add("back", [1]);

		
		background.play("front");
		if (value==null)
			value = new CardValue();
		cardvalue = value;
		centerOrigin();
		this.cb = cbFunc;
 
        // defines left and right as arrow keys and WASD controls
        Input.define("left", [Key.LEFT, Key.A]);
        Input.define("right", [Key.RIGHT, Key.D]);
		
		setHitbox(background.width, background.height);
		
		var taillePinceau =  PAINT_SIZE;
		var ft = { size:PAINT_SIZE, font:"font/m04.TTF", color:PAINT_COLOR }
		var bg = {size:PAINT_SIZE-1,font:"font/m04b.TTF",color:SHADOW_COLOR}
		
		var ta = new Text(cardvalue.t(),  X_OFFSET + taillePinceau, taillePinceau,0,0,bg);
		var tt = new Text(cardvalue.t(),  X_OFFSET + taillePinceau, taillePinceau, 0, 0, ft);
		var la = new Text(cardvalue.l(),  X_OFFSET ,  2 * taillePinceau ,0,0,bg);
		var lt = new Text(cardvalue.l(),  X_OFFSET ,  2 * taillePinceau , 0, 0, ft);
		var ba = new Text(cardvalue.b(),  X_OFFSET +taillePinceau,  3 * taillePinceau,0,0,bg);
		var bt = new Text(cardvalue.b(),  X_OFFSET +taillePinceau,  3 * taillePinceau,0,0,ft);
		var ra = new Text(cardvalue.r(),  X_OFFSET + (2 * taillePinceau ), 2 * taillePinceau , 0, 0, bg);
		var rt = new Text(cardvalue.r(),  X_OFFSET +( 2 * taillePinceau ), 2 * taillePinceau ,0,0,ft);

		var arr = new Array();
		arr = [background,tt,lt,bt,rt,ta,la,ba,ra];
		
		graphic = new Graphiclist(arr);
		background.x = halfWidth;
		background.y = halfHeight;
    }
	
	private function reset(obj:Dynamic) 
	{
			if (backstate) {
				background.play("back");
			} else {
				background.play("front");
			}
			var tween = new VarTween( null, TweenType.OneShot);

			tween.tween(background, "scaleX", 1, 0.1);
			addTween(tween);
			backstate = !backstate;	
	}

	
	var ease:EaseFunction;
	
	override function clicked(view:View) {

	}
		
	public function flip(anim:Bool = true):Void {
		if (anim) {
			var tween = new VarTween( reset, TweenType.OneShot);
			tween.tween(background, "scaleX", 0, 0.1);
			addTween(tween);
		} else {
			if (backstate) {
				background.play("back");
			} else {
				background.play("front");
			}
			backstate = !backstate;	
		}

		
	}
	
	override function  mouseDown(){
		//trace("mouseDown");
		#if mobile
		if (cb != null)
			cb(this);
		#end
	}
	
	override function  mouseOver() {
		#if !mobile
		if (cb != null)
		cb(this);
		#end
	}
 		
	public function getRightValue():Int {
		return cardvalue.right;
	}
 
	public function getLeftValue():Int {
		return cardvalue.left;
	}
	
	public function getTopValue():Int {
		return cardvalue.top;
	}	
	
	public function getBottomValue():Int {
		return cardvalue.bottom;
	}
	
	public override function toString():String {
		return "left=" + getLeftValue + ", right=" + getRightValue();
	}
	
	public function clone():Card {
		return new Card(x, y, cardvalue, cb, slot);
	}
	
	public function isPlayed() {
		return false;
	}
	
	public function getLevel():Int {
		return 1;
	}
	
	public function getColor():Int {
		return 12345;
	}
	
	public function getTotal():Int {
		return cardvalue.getTotal();
	}
	
}