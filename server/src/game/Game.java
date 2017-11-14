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
	private int smallBlind;
	private int bigBlind;
	private int maxUsers = 8;
	
	
	//Game State
	private User dealer;
	private Hand currentHand;
	
	
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
	}

	public boolean addUser(User user) {
		if (users.size() >= maxUsers) {
			return false;
		}else {
			users.add(user);
			Response r = new Response("userJoined");
			r.addParam("user", user);
			r.send(host.getSession());
			return true;
		}
	}
	
	public void startGame() {
		
	}
	
	
}
