package com.cocosw.cardgame;
import com.cocosw.cardgame.uiview.View;
import com.haxepunk.Entity;
import com.haxepunk.Sfx;
import com.haxepunk.World;

/**
 * 处理在手头的牌,包括位置,动画等处理
 * ...
 * @author soar
 */

enum Role {
	ME;
	ENERGY;
}
 
class Hand
{
	public var role:Role;
	public var cards:Array<Card>;
	public var world:World;
	public var selected:Card;
	private var startX:Int;
	private static inline var DIS = 30;
	
	public function new(world:World,role:Role,cards:Array<Card>,startX:Int = -1) 
	{
		this.world = world;
		this.role = role;
		this.cards = cards;
		this.selected = null;
		this.startX = startX;
		initCard();
	}
	
	//初始化发牌的位置
	private function initCard() {
		// 我方在右边,敌人在左边
		// 我方在下,敌人在上
		if (startX == -1)
		role == Role.ME?startX = 430:startX = 30;
		
		var i = 0;
		for (c in cards) {
			
			c.x = startX;
			c.y = (i) * 50 +20;
			c.hand = this;
			//c.layer = 10 - i;
			if (role==ENERGY)
				c.flip(false);
			this.world.add(c);
			c.cb = onCardClicked;
			i++;
		}
	}
	
	// 处理卡片的点击事件
	public function onCardClicked(card:Card) {

		if (card == selected) {
			//resetAll();
			return;
		}
	//	new Sfx(ApplicationMain.getAsset("sfx/hit.mp3")).play(0.3);
		resetAll();
		selected = card;
		trace(card.y);
		// 移出一段
		if (role == ENERGY) //向右
		{
			selected.moveBy(DIS,0);
		} else {
			selected.moveBy(-DIS,0);
		}
	}
	
	
	
	//把现有卡片移动回原有位置
	public function resetAll() {
		if (selected != null) {
			if (role == ENERGY) {
				selected.moveBy( -DIS,0);
			} else {
				selected.moveBy(DIS,0);
			}
		}
		selected = null;
	}
	
	// 一局结束了,处理一些事情
	public function end() {
		for (c in cards) {
			c.cb = null;
		}
		
	}
}