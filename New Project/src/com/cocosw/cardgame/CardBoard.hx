package com.cocosw.cardgame;

/**
 * ...
 * @author soar
 */

 //处理在棋盘中的卡片的逻辑,翻转等逻辑
class CardBoard 
{

	private var cardInBoard:Array<Card>;
	
	public function new() 
	{
		cardInBoard = new Array<Card>();
	}
	
	//放置
	public function place(id:Int, card:Card) {
		if (id>=0 && id<9)
			cardInBoard[id] = card;
	}
	
	//获得
	public function get(id:Int):Card {
		if (id >= 0 && id < 9)
		return cardInBoard[id];
		else
		return null;
	}
	
	//卡片数量
	public function cardNum():Int {
		var num = 0;
		for (c in cardInBoard) {
			if (c != null)
			num++;
		}
		return num;
	}
	
		// 检查所有棋盘上的card,是否有翻转事件发生
	public function checkCards() {
		trace("checkCards");
	}
}