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

	public static inline var kScreenWidth:Int = 480;
	public static inline var kScreenHeight:Int = 320;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x555555;
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
		
				// set resize event
		HXP.stage.addEventListener(Event.RESIZE, function (e:Event) {
			sizechange();
		});
		HXP.stage.align = StageAlign.TOP;
		sizechange();


	}

	public static function main()
	{
		new Main();
	}

	public function sizechange() {
		HXP.screen.scaleX = HXP.screen.scaleY = 1.2; // set screen scale to 1x1
		HXP.resize(HXP.stage.stageWidth, HXP.stage.stageHeight);
	}
	
}
