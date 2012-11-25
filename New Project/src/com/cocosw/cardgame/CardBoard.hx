package com.cocosw.cardgame;

/**
 * ...
 * @author soar
 */

 enum Result {
	 WIN;
	 LOSE;
	 DRAW;
 }
 
 //处理在棋盘中的卡片的逻辑,翻转等逻辑
class CardBoard 
{

	private var cardInBoard:Array<Card>;
	
	public function new() 
	{
		cardInBoard = new Array<Card>();
	}
	
	//放置
	public function place(slot:Slot, card:Card) {
		if (slot.id>=0 && slot.id<9) {
			cardInBoard[slot.id] = card;
			slot.addCard(card);
		}
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
	
	
	public function reset() {
		cardInBoard = new Array<Card>();
	}
	
	//获得某张卡片邻近的4张卡片集合
	public function getNearCard(id:Int):Array<Card> {
		var col:Int = Math.floor(id / 3); //行
		var row:Int = id % 3; //列
		var out = new Array<Card>();

		out.push(get(getidfromxy(col, row - 1)));
		out.push(get(getidfromxy(col, row + 1)));
		out.push(get(getidfromxy(col-1, row ))); 
		out.push(get(getidfromxy(col + 1, row )));		
		return out;
	}
		
	private function getidfromxy(x:Int, y:Int) {
		if (x<0 || x>2 || y<0 || y>2)
		return -1;
		else
		return x * 3 + y;
	}
	
	public function result() {
		
	}
}