package com.cocosw.cardgame;
import com.cocosw.cardgame.uiview.View;
import com.haxepunk.Entity;
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
	private static inline var DIS = 30;
	
	public function new(world:World,role:Role,cards:Array<Card>) 
	{
		this.world = world;
		this.role = role;
		this.cards = cards;
		this.selected = null;
		initCard();
	}
	
	//初始化发牌的位置
	private function initCard() {
		var sx = 0;
		// 我方在右边,敌人在左边
		// 我方在下,敌人在上
		role == Role.ME?sx = 400:sx = 20;
		
		var i = 0;
		for (c in cards) {
			
			c.x = sx;
			c.y = (i + 1) * 50;
			trace(c.y);
			c.hand = this;
			if (role==ENERGY)
				c.flip();
			this.world.add(c);
			c.cb = onCardClicked;
			i++;
		}
	}
	
	// 处理卡片的点击事件
	public function onCardClicked(card:Card) {
		
		if (card == selected) {
			return;
		} 
		resetAll();
		selected = card;
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
	
}