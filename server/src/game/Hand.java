//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
package game;

import java.util.Set;

import server.Response;

public class Hand {
	private User nextToMove;
	private Game game;
	private Pot pot = new Pot();
	public Pot getPot() {
		return pot;
	}

	private int currentBet = 0;
	private int round = 0;
	private User lastBetter = null;
	private User dealer;
	
	public Hand(Game game, User dealer) {
		this.dealer = dealer;
		this.game = game;
	}
	
	public void startHand() {
		game.resetCurrentBet();
		User smallBlind = game.userAfter(dealer);
		User bigBlind = game.userAfter(smallBlind);
		nextToMove = game.userAfter(bigBlind);
		currentBet = game.getBigBlind();
		smallBlind.betBlind(game.getSmallBlind());
		bigBlind.betBlind(currentBet);
		game.resetFolded();
		lastBetter = null;
		requestMove();
	}
	
	public void placeBet(User u, int amount) {
		System.out.println(currentBet);
		pot.placeBet(u, amount);
		if (u.getCurrentBet() > currentBet) {
			lastBetter = u;
		}
		currentBet = Math.max(u.getCurrentBet(), currentBet);
		
	}
	
	public boolean isRoundOver() {
		User next = game.userAfter(nextToMove);
		while (next.isFolded()) {
			next = game.userAfter(next);
		}
		return nextToMove == next;
	}
	
	
	public void requestMove() {
		if (isRoundOver()) {
			finishHand();
		}else if (lastBetter == nextToMove) {
			if (round == 3) {
				finishHand();
			}else {
				lastBetter = null;
				nextToMove = game.userAfter(dealer);
				currentBet = 0;
				round++;
				game.resetCurrentBet();
				requestMove();
			}
		}else {
			if (lastBetter == null) {
				lastBetter = nextToMove;
			}
			if (nextToMove.isFolded() || !nextToMove.canMakeMove()) {
				nextToMove = game.userAfter(nextToMove);
				requestMove();
			} else {
				Response playerToMoveResponse = new Response("playerToMove");
				playerToMoveResponse.addParam("id", nextToMove.getId());
				playerToMoveResponse.addParam("chips", nextToMove.getChips());
				
				game.sendResponseToAll(playerToMoveResponse);
				
				Response moveOptionsResponse = new Response("moveOptions");
				if (currentBet > nextToMove.getCurrentBet()) {
					moveOptionsResponse.addParam("canCheck", false);
				}else {
					moveOptionsResponse.addParam("canCheck", true);
				}
				int toCall = currentBet - nextToMove.getCurrentBet();
				moveOptionsResponse.addParam("callAmount", Math.min(toCall, nextToMove.getChips()));
				if (toCall < nextToMove.getChips()) {
					moveOptionsResponse.addParam("canRaise", true);
				}else {
					moveOptionsResponse.addParam("canRaise", false);
				}
				int maxRaise = nextToMove.getChips() - toCall;
				moveOptionsResponse.addParam("maxRaise", maxRaise);
				moveOptionsResponse.addParam("minRaise", game.getBigBlind() < maxRaise ? game.getBigBlind() : maxRaise);
				if (toCall == 0) {
					moveOptionsResponse.addParam("canCall", false);
				}else {
					moveOptionsResponse.addParam("canCall", true);
				}
				moveOptionsResponse.addParam("potSize", pot.getPotSize());
				moveOptionsResponse.send(nextToMove);
			}
		}
	}
	
	
	public void finishHand() {
		System.out.println("Round is over");
		pot.checkRedeem();
		if(!pot.isEmpty()) {
			Set<User> usersInPot = pot.getUsersInPot();
			Response r = new Response("chooseWinner");
			r.addParam("numUsers", usersInPot.size());
			int i = 1;
			for (User u : usersInPot) {
				r.addParam(String.valueOf(i), u.getId());
				i++;
			}
			r.send(game.getHost());
		}else {
			game.newHand();
		}
	}
	
	public void goToNextPlayer() {
		nextToMove = game.userAfter(nextToMove);
		requestMove();
	}

}
