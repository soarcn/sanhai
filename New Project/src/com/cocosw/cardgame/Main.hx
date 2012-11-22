package com.cocosw.cardgame;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import nme.Assets;
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

	public static inline var kScreenWidth:Int = 640;
	public static inline var kScreenHeight:Int = 480;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x555555;
	public static inline var kProjectName:String = "HaxePunk";
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
	}

	public static function main()
	{
		new Main();
	}

}
