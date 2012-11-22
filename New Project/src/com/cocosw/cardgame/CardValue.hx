package com.cocosw.cardgame;

/**
 * ...
 * @author soar
 */

class CardValue 
{

	public var top:Int = 1;
	public var left:Int = 1;
	public var right:Int = 1;
	public var bottom:Int = 1;
	
	
	public function new(top=1,left=1,right=1,bottom=1) 
	{
		this.top = top;
		this.left = left;
		this.right = right;
		this.bottom = bottom;
	}
	
	public static function randomCard():CardValue
	{
		return new CardValue(ran(), ran(), ran(), ran());
	}
	
	private static function ran():Int {
		return Math.round(Math.random() * 10);
	}
	
	public function t():String {
		return num2Str(top);
	}
	
	public function l():String {
		return num2Str(left);
	}
	
	public function r():String {
		return num2Str(right);
	}
	
	public function b():String {
		return num2Str(bottom);
	}
	
	public function getTotal():Int {
		return top+right+left+bottom;
	}
	
	private static function num2Str(value:Int):String {
		if (value > 9)
		return "A";
		else return Std.string(value);
	}
}