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
	private var currenthand:Hand;	
	private var myhand:Hand;	
	private var aihand:Hand;	
	private var sx = 120;
	private var sy = 50;
	
    public function new()
    {
        super();
		board = new CardBoard();
    }
     
    public override function begin()
    {
	   initBoard ();
	   myhand = initMyCard();
	   aihand = initAICard();
	   currenthand = myhand;
    }
	
	//初始化我方卡片
	private function initMyCard():Hand {
		return new Hand(this,ME, CardManager.generateXCards(5));
	}
	
	//初始化对手的卡片
	private function initAICard():Hand {
		return new Hand(this,ENERGY, CardManager.generateXCards(5));
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
		var card = currenthand.selected;
		if (card!=null){
			board.place(slot, card);
			board.checkCards();
			changeHand();
		}
	}
	
	//更换选手
	private function changeHand() {
		currenthand.selected = null;
		currenthand = currenthand == aihand?myhand:aihand;
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