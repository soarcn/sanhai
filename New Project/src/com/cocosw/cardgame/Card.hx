package com.cocosw.cardgame;

import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.cocosw.cardgame.uiview.View;

/**
 * ...
 * @author soar
 */

typedef CardCallback = Card -> Void;

class Card extends View
{
	
	
	private var velocity:Float;
    private var sprite:Image;
	
	//private var name:String;
	private var element:String;
	private var level:Int;
	//private var edition;
	//private var number;
	private var locked = false;
	private var selected = false; 
	private var hasMalus = false; 
	private var hasBonus = false;
/*	private var redFace; 
	private var blueFace;
	private var backFace;
	private var cardView;
	private var color;
	private var rewardDirectColor;
	private var visible:Bool;*/
	
	private var animTempColor:Int;
	//背景的状态
	private var backstate = true;
	//背景图
	private var background:Spritemap;
	
	static public inline var  CARDHIGHT:Int = 75;
	static public inline var CARDWIGHT:Int = 75;
	
	static private inline var PAINT_SIZE:Int = 12;
	static private  inline var PAINT_COLOR:Int = 0xff000000;
	static private inline var SHADOW_COLOR:Int = 0xffffffff;
    static private  inline  var SHADOW_OFFSET:Int = 1;
	
	public var cb:CardCallback;
	public var cardvalue:CardValue;
	public var slot:Slot;
	public var hand:Hand;
	
    public function new(x:Float, y:Float,value:CardValue=null, cbFunc:CardCallback = null, slot:Slot)
    {
        super(x, y);
		this.slot = slot;
        // create a new spritemap (image, frameWidth, frameHeight)
        sprite = new Image("gfx/toss.png");
		
		background = new Spritemap("gfx/cardback.png",CARDHIGHT,CARDWIGHT);
             
        background.add("front", [0]);
        background.add("back", [1]);
		
		background.play("front");
		if (value==null)
			cardvalue = new CardValue();
		else
			cardvalue = value;
		
		this.cb = cbFunc;
 
        // defines left and right as arrow keys and WASD controls
        Input.define("left", [Key.LEFT, Key.A]);
        Input.define("right", [Key.RIGHT, Key.D]);
		
		setHitbox(background.width, background.height);
		
		var taillePinceau =  PAINT_SIZE;
	
		
		var tt = new Text(cardvalue.t(),  50+(3 * taillePinceau / 2 + 2) / 2, taillePinceau);
		var lt = new Text(cardvalue.l(),  50+3,  3 * taillePinceau / 2);
		var bt = new Text(cardvalue.b(),  50+(3 * taillePinceau / 2 + 2) / 2,  2 * taillePinceau);
		var rt = new Text(cardvalue.r(),  50+(3 * taillePinceau / 2) - 2, 3 * taillePinceau / 2);

		var arr = new Array();
		arr = [background,tt,lt,bt,rt];
		
		graphic = new Graphiclist(arr);
		
        velocity = 0;
    }
 
    // sets velocity based on keyboard input
    private function handleInput()
    {
        velocity = 0;
 
        if (Input.check("left"))
        {
            velocity = -2;
        }
 
        if (Input.check("right"))
        {
            velocity = 2;
        }
    }
	
	var ease:EaseFunction;
	
	override function clicked(view:View) {
		if (cb != null)
		
		cb(this);
	}
	
	public function flip():Void {
		trace("flip");
		if (backstate) {
			background.play("back");
		} else {
			background.play("front");
		}
		backstate = !backstate;	
	}
	
	override function  mouseDown(){
		//trace("mouseDown");
	}
	
	override function  mouseOver(){
		//trace("mouseOver");
	}
 
    private function setAnimations()
    {
 
            // this will flip our sprite based on direction
            if (velocity < 0) // left
            {
                background.flipped = true;
            }
            else // right
            {
                background.flipped = false;
            }
    }
 
    public override function update()
    {
		
        handleInput();
 
        moveBy(velocity, 0);
 
        setAnimations();
 
        super.update();
    }
 
}