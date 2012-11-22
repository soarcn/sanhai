package com.cocosw.cardgame;
import com.haxepunk.Entity;

/**
 * 处理在手头的牌,包括位置,动画等处理
 * ...
 * @author soar
 */

enum Role {
	ME,
	ENERGY
}
 
class Hand extends View
{
	public var role:Role;
	public var cards:Array<Card>
	
	public function new(role:Role=ME,cards:Array<Card>) 
	{
		this.role = role;
		this.cards = cards;
		initCard();
	}
	
	//初始化发牌的位置
	private function initCard() {
		var sx = 0;
		role == Role.ME?sx = 20:sx = 350;
		
		var i = 0;
		for (c in cards) {
			c.x = sx;
			c.y = (i + 1) * 50;
			c.hand = this;
			this.world.add(c);
		}
	}
	
}