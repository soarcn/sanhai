package com.cocosw.cardgame;
 
import com.cocosw.cardgame.Card;
import com.cocosw.cardgame.entry.Toss;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.masks.Grid;
import com.haxepunk.Sfx;
import com.haxepunk.tweens.misc.AngleTween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.tweens.sound.Fader;
import com.haxepunk.utils.Ease;
import com.haxepunk.World;
import nme.geom.Point;
import com.haxepunk.Tween;
 
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
	private var sx = 130;
	private var sy = 30;
	private var mather:Matcher;
	// 我方是否第一手
	private var meIsFirst:Bool;
	private static var music:Sfx;
	private var fading:Bool;
	private var toss:Toss;
	
	private var readyForCard = false;
	
    public function new()
    {
        super();
		board = new CardBoard();
    }
     
    public override function begin()
    {
		var bg = new Image("gfx/background_landscape.png");
		bg.scale = 0.5;
		addGraphic(bg,100);
		reset();
		
		//开发阶段把音乐关掉
		#if !debug
		if (music == null)
			music = new Sfx("music/shuffle_or_boogie.mp3");

		music.loop();
		#end
    }
	
	public function musicoff(off:Bool) {
		if (music != null) {
			if (off)
				music.stop();
			else
				music.play();
		}
	}
	
	//重新初始化棋盘
	public function reset() {
	    initBoard ();
		myhand = initMyCard();
		aihand = initAICard();
		board.reset();
		mather = new Matcher(board);
		
		meIsFirst = Math.random()*10 >5;
		if (meIsFirst) {
			currenthand = myhand;
		} else {
			currenthand = aihand;
		}
		toss = new Toss();		
		var rotate = new AngleTween(pointToHand, TweenType.OneShot);
		toss.startPointToMe(meIsFirst, rotate);
		add(toss);
	}
	
	private function pointToHand(obj:Dynamic) {
		tossMoveToHand();
		
	}
	
	private function start(obj:Dynamic) {
		readyForCard = true;
	}
	
	private function tossMoveToHand() {
		var motion = new LinearMotion(start, TweenType.OneShot);
		if (currenthand == aihand) {
			motion.setMotion(HXP.screen.width / 2, HXP.screen.height / 2, 60, 350, 1);
		} else {
			motion.setMotion(HXP.screen.width / 2, HXP.screen.height / 2, 600, 350, 1);
		}
		toss.addTween(motion);
	}
	
	//初始化我方卡片
	private function initMyCard():Hand {
		return new Hand(this,ME, CardManager.generateXCards(5),410);
	}
	
	//初始化对手的卡片
	private function initAICard():Hand {
		return new Hand(this,ENERGY, CardManager.generateXCards(5),30);
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
		if (readyForCard == false)
			return;
		var card = currenthand.selected;
		if (card != null) {
			card.cb = onCardClicked;
			board.place(slot, card);
			checkCards(slot.id);
			changeHand();
		}
		if (board.cardNum() == 9)
			finishRound();
	}
	
	// 检查所有棋盘上的card,是否有翻转事件发生
	public function checkCards(id:Int) {
		trace("checkCards");
		var cards = mather.check(id);
		if (cards != null)
		for (c in cards) {
			if (c != null)
			c.flip();
		}
	}
	
	//更换选手
	private function changeHand() {
		currenthand.selected = null;
		currenthand = currenthand == aihand?myhand:aihand;
		readyForCard = true;
	}
	
	
	public function onCardClicked(card:Card) {
		if (card.slot!=null)
			dealCardInBoard(card);
	}
	
	//处理棋盘中卡片的点击事件
	public function dealCardInBoard(card:Card) {
		trace(card.slot.id);
		
	}
	
	// 一局结束
	public function finishRound() {
		myhand.end();
		aihand.end();		
		board.result();
	}
	
	public function pause() {
		active = false;
	}
	
	
	
}