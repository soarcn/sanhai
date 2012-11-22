package com.cocosw.cardgame.robots;
import com.cocosw.cardgame.Card;

/**
 * ...
 * @author soar
 */

class Action 
{
	private var valeur:Int;
	private var position:Int;
	private var card:Card;
	
	public function new( c:Card, pos:Int, val:Int)
	{
		valeur = val;
		card = c;
		position = pos;
	}
	
	public function getValue():Int
	{
		return valeur;
	}
	
	public function getCardName():String
	{
		return card.getFullName();
	}
	
	public function  getCard():Card
	{
		return card;
	}
	
	public function getCell():Int
	{
		return position;
	}
}
