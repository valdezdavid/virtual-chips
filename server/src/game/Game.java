package game;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import server.Response;

public class Game {
	
	private static Map<Integer, Game> games = new HashMap<Integer, Game>();
	private int id;
	private User host;
	private List<User> users = new ArrayList<User>();
	
	//Game settings
	private int smallBlind = 5;

	private int bigBlind = 10;
	private int numUsers = 2;
	
	
	//Game State
	private User dealer;
	private Hand currentHand;
	
	
	public Hand getCurrentHand() {
		return currentHand;
	}


	public Game(User host) {
		this.host = host;
		users.add(host);
		// create random ID for user
		id = (int)(Math.random()*Integer.MAX_VALUE);
		
		//make sure id is unique
		while (games.containsKey(id)) {
			id = (int)(Math.random()*Integer.MAX_VALUE);
		}
		games.put(id, this);
		
	}


	public int getId() {
		return id;
	}
	
	public static boolean gameExists(int id) {
		return games.containsKey(id);
	}
	
	public static Game getGame(int id) {
		return games.get(id);
	}
	
	public void removeUser(User user) {
		users.remove(user);
		if (users.size() == 0) {
			destroyGame();
		}else if (user == host) {
			host = users.get(0);
		}
	}

	public boolean addUser(User user) {
		if (users.size() >= numUsers) {
			return false;
		}else {
			users.add(user);
			Response r = new Response("userJoined");
			r.addParam("user", user);
			r.send(host);
			return true;
		}
	}
	
	public void sendResponseToAll(Response r) {
		for (User u : users) {
			r.send(u);
		}
	}
	
	public void startGame() {
		dealer = host;
		if (users.size() == numUsers) {
			currentHand = new Hand(this, dealer);
			currentHand.startHand();
		}
	}
	
	public void destroyGame() {
		games.remove(id);
	}
	
	public User userAfter(User user) {
		int index = users.indexOf(user) + 1;
		index %= users.size();
		return users.get(index);
	}
	
	public int getSmallBlind() {
		return smallBlind;
	}
	
	public int getBigBlind() {
		return bigBlind;
	}
	
	public void resetFolded() {
		for (User u : users) {
			u.resetFolded();
		}
	}
	public void resetCurrentBet() {
		for (User u : users) {
			u.resetCurrentBet();
		}
	}
	
	
}
