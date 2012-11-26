package com.cocosw.cardgame;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import nme.Assets;
import nme.display.StageAlign;
import nme.events.Event;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author soar
 */

class Main extends Engine
{

	public static inline var kScreenWidth:Int = 960;
	public static inline var kScreenHeight:Int = 640;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x000000;
	public static inline var kProjectName:String = "山海斗";
	private var Score:TextField;

	public function new()
	{
		super(kScreenWidth, kScreenHeight, kFrameRate, false);
	}

	override public function init()
	{
		HXP.screen.color = kClearColor;
		HXP.screen.scale = 1;
		HXP.world = new GameWorld();
		HXP.defaultFont = "font/m04b.TTF";
		
				// set resize event
		HXP.stage.addEventListener(Event.RESIZE, function (e:Event) {
			sizechange();
		});
	//	HXP.stage.align = StageAlign.TOP;
		sizechange();


	}

	public static function main()
	{
		new Main();
	}

	public function sizechange() {
		var scale = Math.min(HXP.windowWidth/ HXP.width, HXP.windowHeight / HXP.height);
		HXP.screen.scaleX = HXP.screen.scaleY = scale; // set screen scale to 1x1
		HXP.screen.
	}
	
}
