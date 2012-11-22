package com.cocosw.cardgame.robots;
import com.cocosw.cardgame.Card;

/**
 * ...
 * @author soar
 */

class EasyBots 
{

	public var ME:Int;
	
	private var  deck:Array<Card>;
	private var  board:Array<Card>;
	private var  elements:Array<String>;
	private var  elementaire = false;
	private var  identique = false;
	private var  plus = false;
	private var  memeMur = false;
	
	
	public function new(me:Int,  deck:Array<Card>,  board:Array<Card>,  elements:Array<String>, identique=false, plus=false, memeMur=false, combo=false, elementaire=false)
	{	
		ME = me;
		this.deck = deck;
		this.board = board;
		this.elements = elements;
		this.identique = identique;
		this.plus = plus;
		this.memeMur = memeMur;
		
		this.elementaire = elementaire;
	}
	
	public function getPlayerValue():Int
	{
		return ME;
	}
	
	public function islastAction():Bool
	{
		var empty = 0;
		
		for (b in board) {
			if (b == null)
			empty++;
		}
		return empty == 2;

	}
	
	public function isFirstTurn():Bool
	{
		var empty = 0;
		for (b in board) 
		{
			if (b == null)
				empty++;
		}
		return empty == board.length;
	}
	
	public function isNewCardStrongerForLastDefense( newCard:Card, oldCard:Card, cell:Int):Bool
	{
		for (c in 0...board.length)
		{
			if (board[c] == null && c != cell)
			{
				if (cell == c - 1 && cell % 3 != 0) // On v�rifie la valeur de droite
				{
					return newCard.getRightValue() > oldCard.getRightValue();
				}
				else if (cell == c + 1 && c % 3 != 0) // On v�rifie la valeur de gauche
				{
					return newCard.getLeftValue() > oldCard.getLeftValue();
				}
				else if (cell == c + 3) // On v�rifie la valeur du haut
				{
					return newCard.getTopValue() > oldCard.getTopValue();
				}
				else if (cell == c - 3) // On v�rifie la valeur du bas
				{
					return newCard.getBottomValue() > oldCard.getBottomValue();
				}
			}
		}
		return false;
	}
	
	// Link� au moteur de jeu, permet de jouer le prochain coup
	public function nextMove():Action
	{
		var carteAJouer:Card;
		var caseOuJouer = 0;
		var gain = -1;	
		
		if (isFirstTurn()) // Si c'est la premi�re carte � �tre pos�e sur le plateau
		{
			// On joue la carte de niveau le plus faible dans un angle laissant apparaitre ses 2 valeurs les plus faibles
			var  c:Card;
			for (card in deck)
			{
				if (!card.isPlayed())
				{
					if (c == null || card.getLevel() < c.getLevel() || (card.getLevel() == c.getLevel() && card.getTotal() < c.getTotal()))
						c = card;
				}
			}
			
			var leftStronger = true;
			var topStronger = true;
			var betterToPlayMid = false;
			if (c.getLeftValue() < c.getRightValue())
				leftStronger = false;
			else if (c.getLeftValue() == c.getRightValue() && c.getLeftValue() >= 6)
				betterToPlayMid = true;
			
			if (c.getTopValue() < c.getBottomValue())
				topStronger = false;
			else if (c.getTopValue() == c.getBottomValue() && c.getTopValue() >= 6)
				betterToPlayMid = true;
			
			var cell = -1;
			if (betterToPlayMid)
				cell = 4;
			else if (topStronger && leftStronger)
				cell = 0;
			else if (topStronger)
				cell = 2;
			else if (leftStronger)
				cell = 6;
			else
				cell = 8;
			
			carteAJouer = c;
			caseOuJouer = cell;
			gain = 0;
		}
		else
		{	
			for (c in 0...board.length)
			{
				if (board[c] == null) // Pour chaque case libre du plateau
				{
					for (card in deck)
					{
						if (!card.isPlayed()) // Pour chaque carte pouvant �tre jou�e
						{
							var g = gain(board, c, card.clone());
							// On joue la carte de niveau le plus faible fournissant le gain maximal sauf si c'est le dernier tour o� alors on joue la carte de niveau max ayant le gain maximal;
							if (g > gain || (g == gain && ((!islastAction() && card.getLevel() < carteAJouer.getLevel()) || (islastAction() && isNewCardStrongerForLastDefense(card, carteAJouer, c)))))
							{
								carteAJouer = card;
								caseOuJouer = c;
								gain = g;
							}
						}
					}
				}
			}
		}
		// On joue la carte qui maximise le gain sur ce tour, en prenant celle de plus faible niveau en cas d'egalite
		return new Action(carteAJouer, caseOuJouer, gain);
	}
	
	private function  appliquerRegleElementaire( c:Card, cell:Int)
	{
		if (elements[cell] == null || elements[cell] == "")
			return;
		
		if (elements[cell] == c.getElement())
			c.bonusElementaire();
		else
			c.malusElementaire();
	}
	
	// Renvoie le nombre de cartes retournees en posant la carte What en Where
	private function  gain( plateau:Array<Card>, where:Int, what:Card):Int
	{
		if (elementaire)
			appliquerRegleElementaire(what, where);
		
		var gain = 0;
		
		if (where % 3 == 0) // Carte colonne gauche
		{
			var c = plateau[where + 1];
			if (c != null) // Si il y a une carte a sa droite
			{
				if (c.getColor() != ME && what.getRightValue() > c.getLeftValue()) // Celle jou�e est plus forte
				{
					gain += 1;
				}
			}
		}
		else if (where % 3 == 1) // Colonne du milieu
		{
			var c = plateau[where + 1];
			if (c != null) // Si il y a une carte a sa droite
			{
				if (c.getColor() != ME && what.getRightValue() > c.getLeftValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
			
			c = plateau[where - 1];
			if (c != null) // Si il y a une carte a sa gauche
			{
				if (c.getColor() != ME && what.getLeftValue() > c.getRightValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
		}
		else // Colonne de droite
		{
			var c = plateau[where - 1];
			if (c != null) // Si il y a une carte a sa gauche
			{
				if (c.getColor() != ME && what.getLeftValue() > c.getRightValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
		}
		
		if (where / 3 == 0) // Ligne du haut
		{
			var c = plateau[where + 3];
			if (c != null) // Si il y a une carte en dessous
			{
				if (c.getColor() != ME && what.getBottomValue() > c.getTopValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
		}
		else if (where / 3 == 1) // Ligne du milieu
		{
			var c = plateau[where + 3];
			if (c != null) // Si il y a une carte en dessous
			{
				if (c.getColor() != ME && what.getBottomValue() > c.getTopValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
			
			c = plateau[where - 3];
			if (c != null) // Si il y a une carte en dessus
			{
				if (c.getColor() != ME && what.getTopValue() > c.getBottomValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
		}
		else // Ligne du bas
		{
			var c = plateau[where - 3];
			if (c != null) // Si il y a une carte en dessus
			{
				if (c.getColor() != ME && what.getTopValue() > c.getBottomValue()) // Celle jou�e est plus forte
				{
					gain += 1; // On retourne l'autre
				}
			}
		}

		if (identique)
		{
			var gainSame = gainSame(Engine.OPPONENT, plateau, what, where);
			if (gainSame > 0)
				gain += gainSame;
		}
		if (plus)
		{
			var gainPlus = gainPlus(Engine.OPPONENT, plateau, what, where);
			if (gainPlus > 0)
				gain += gainPlus;
		}
		
		return gain;
	}
	
	private function gainSame( player:Int,  board:Array<Card>, what:Card,  cell:Int):Int
	{
		var gain = 0;
		ArrayList<Integer> cards = new ArrayList<Integer>(); // Cartes subissant/permettant Identique
		var carteAdverse = 0;
		
		if (cell - 3 >= 0 && board[cell - 3] != null) // carte du dessus si existante
		{
			if (board[cell - 3].getBottomValue() == what.getTopValue())
			{
				cards.add(cell - 3);
				if (board[cell - 3].getColor() != player) carteAdverse += 1;
			}
		}
		else if (cell - 3 < 0 && memeMur) // Regle MemeMur
		{
			if (10 == what.getTopValue())
			{
				cards.add(-1);
			}
		}
		if (cell + 3 < board.length && board[cell + 3] != null) // carte du dessous si existante
		{
			if (board[cell + 3].getTopValue() == what.getBottomValue())
			{
				cards.add(cell + 3);
				if (board[cell + 3].getColor() != player) carteAdverse += 1;
			}
		}
		else if (cell + 3 >= board.length && memeMur) // Regle MemeMur
		{
			if (10 == what.getBottomValue())
			{
				cards.add(-1);
			}
		}
		if (cell % 3 <= 1 && board[cell + 1] != null) // colonne gauche ou milieu
		{
			if (board[cell + 1].getLeftValue() == what.getRightValue())
			{
				cards.add(cell + 1);
				if (board[cell + 1].getColor() != player) carteAdverse += 1;
			}
		}
		else if (cell % 3 == 2 && memeMur) // Regle MemeMur
		{
			if (10 == what.getRightValue())
			{
				cards.add(-1);
			}
		}
		if (cell % 3 >= 1 && board[cell - 1] != null) // colonne droite ou milieu
		{
			if (board[cell - 1].getRightValue() == what.getLeftValue())
			{
				cards.add(cell - 1);
				if (board[cell - 1].getColor() != player) carteAdverse += 1;
			}
		}
		else if (cell % 3 == 0 && memeMur) // Regle MemeMur
		{
			if (10 == what.getLeftValue())
			{
				cards.add(-1);
			}
		}
		
		if (cards.size() >= 2 && carteAdverse >= 1)
		{
			ArrayList<Integer> swapped = new ArrayList<Integer>(); // Cartes swapped
			for (c in cards) // Pour chaque carte, on les retourne si besoin est
			{
				if (c != -1)
				{
					var card = board[c];
					if (card.getColor() != player)
						swapped.add(c);
				}
			}
			gain = carteAdverse;
		}
		
		return gain;
	}
	
	// Applique la regle Plus sur le plateau
	private function gainPlus( player:Int, board:Array<Card>, what:Card,  cell:Int):Int
	{
		var cards = new Array<Card>();
		var numeros = new Array<Int>();
		var gain = new ArrayList<Integer>();
		
		numeros[0] = cell - 3;
		numeros[1] = cell - 1;
		numeros[2] = cell + 3;
		numeros[3] = cell + 1;
		if (cell - 3 >= 0) cards[0] = board[cell - 3];
		if (cell + 3 < board.length) cards[2] = board[cell + 3];
		if (cell % 3 <= 1) cards[3] = board[cell + 1];
		if (cell % 3 >= 1) cards[1] = board[cell - 1];
		
		for (i in 0...3)
		{ 
			var condition = false;
			if (cards[i] != null)
			{
				var somme = 0;
				if (i == 0) somme = what.getTopValue() + cards[i].getBottomValue();
				else if (i == 1) somme = what.getLeftValue() + cards[i].getRightValue();
				else if (i == 2) somme = what.getBottomValue() + cards[i].getTopValue();
				
				if (player != cards[i].getColor()) condition = true;
				
				for (j in i+1...4)
				{
					if (cards[j] != null)
					{
						var somme2 = 0;
						if (j == 3) somme2 = what.getRightValue() + cards[j].getLeftValue();
						else if (j == 1) somme2 = what.getLeftValue() + cards[j].getRightValue();
						else if (j == 2) somme2 = what.getBottomValue() + cards[j].getTopValue();
						
						if (player != cards[j].getColor()) condition = true;
						
						if (somme == somme2 && condition) // Toutes les conditions remplies
						{
							if (cards[i].getColor() != player)
							{
								gain.add(i);
							}
							if (cards[j].getColor() != player) 
							{
								gain.add(j);
							}
						}
					}
				}
			}
		}
		
		return gain.size();
	}
	
}