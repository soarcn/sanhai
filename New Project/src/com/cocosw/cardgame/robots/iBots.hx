package com.cocosw.cardgame.robots;

/**
 * ...
 * @author soar
 */

public interface iBot 
{
	public function nextMove:Action();

	public function getPlayerValue:Int();
}