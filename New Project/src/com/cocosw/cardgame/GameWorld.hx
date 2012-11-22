package com.cocosw.cardgame;
 
import com.cocosw.cardgame.Card;
import com.cocosw.cardgame.robots.EasyBots;
import com.haxepunk.graphics.Text;
import com.haxepunk.World;
import nme.geom.Point;
 
class GameWorld extends World
{
 
	private static inline var NUM_COLUMNS:Int = 3;
	private static inline var NUM_ROWS:Int = 3;
	private static inline var GAP:Int = 16;
	private static inline var CARDNUM = 5;
	private var board:CardBoard;
	
	
	private var sx = 150;
	private var sy = 50;
	
    public function new()
    {
        super();
		board = new CardBoard();
    }
     
    public override function begin()
    {
	   initBoard ();
	   initMyCard();
	   initAICard();
    }
	
	//初始化我方卡片
	private function initMyCard() {
		var hand = new Hand(Role.ME, cards).;
	}
	
	//初始化对手的卡片
	private function initAICard() {
		
	}
     
		//根据行列获得点位
	private function getPosition (row:Int, column:Int):Point {
		return new Point (sx+column * (Card.CARDHIGHT + GAP), sy+row * (Card.CARDHIGHT + GAP));
		
	}
	
	// 初始化整个棋盘
	private function initBoard ():Void {
		var id = 0;
		for (column in 0...NUM_COLUMNS) {
			for (row in 0...NUM_ROWS) {	
				var position = getPosition (column , row);
				add(new Slot(position.x, position.y, id,onSlotClicked));
				id++;
			}	
		}
	}
	
	//点击棋盘空位发生的事件
	private function onSlotClicked(slot:Slot):Void {	
		board.place(slot.id, generateCard(null, onCardClicked, slot));
		slot.addCard(board.get(slot.id));
		board.checkCards();
	}
	
	//生成一张随机卡片,位置为传入的pos,或者为0
	private function generateCard(pos:Point,onCardClicked:CardCallback,slot:Slot):Card {
		if (pos == null)
			pos = new Point(0, 0);
		return new Card(pos.x, pos.y,CardValue.randomCard(),onCardClicked,slot);
	}
	

	
	public function onCardClicked(card:Card) {
		if (card.slot!=null)
			dealCardInBoard(card);
		else
			dealCardInHand(card);
	}
	
	//处理棋盘中卡片的点击事件
	public function dealCardInBoard(card:Card) {
		trace(card.slot.id);
		
	}
	
	//处理在手中的卡片点击事件
	public function dealCardInHand(card:Card) {
		//card.moveBy(30);
	}
	
}