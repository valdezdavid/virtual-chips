package game;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.websocket.Session;

import server.Response;

public class User {
	static private Map<Integer, User> users = new HashMap<Integer, User>();
	private Session session;
	private Game currentGame;
	private int id;
	private String username;
	private String userId;
	private boolean authenticated = false;
	
	
	public User(Session session) {
		this.session = session;
		// create random ID for user
		id = (int)(Math.random()*Integer.MAX_VALUE);
		
		//make sure id is unique
		while (users.containsKey(id)) {
			id = (int)(Math.random()*Integer.MAX_VALUE);
		}
		users.put(id, this);
		
	}
	
	public String prettyPrintMap(Map<String, Object> map) {
		if (map == null) return "";
        StringBuilder sb = new StringBuilder();
        Iterator<Entry<String, Object>> iter = map.entrySet().iterator();
        while (iter.hasNext()) {
            Entry<String, Object> entry = iter.next();
            sb.append(entry.getKey());
            sb.append('=').append('"');
            sb.append(entry.getValue());
            sb.append('"');
            if (iter.hasNext()) {
                sb.append(',').append(' ');
            }
        }
        return sb.toString();

    }

	
	public void executeCommand(String command, Map<String, Object> params) {
		System.out.println("Executing '" + command + "'");
		System.out.println(prettyPrintMap(params));
		
		switch (command) {
		case "login":
			login(params.get("username").toString(), params.get("password").toString());
			break;
		case "register":
			register(params.get("username").toString(), params.get("password").toString());
			break;
		case "startGame":
			startGame();
			break;
		case "joinGame":
			joinGame(((Double)params.get("id")).intValue());
			break;
		case "leaveGame":
			leaveGame();
			break;
		case "bet":
			bet((int)params.get("amount"));
			break;
		case "call":
			call();
			break;
		case "check":
			check();
			break;
		case "getGameInfo":
			getGameInfo();
			break;
		}
	}
	
	private void login(String username, String password) {
		// TODO check database
		this.username = username;
		authenticated = true;
		Response r = new Response("login");
		r.addParam("success", true);
		r.send(session);
	}
	
	private void register(String username, String password) {
		// TODO add to database
		this.username = username;
		authenticated = true;
		Response r = new Response("register");
		r.addParam("success", true);
		r.send(session);
	}
	
	private void startGame() {
		currentGame = new Game(this);
		Response r = new Response("startGame");
		r.addParam("success", true);
		r.addParam("id", currentGame.getId());
		r.send(session);
	}
	
	private void joinGame(int id) {
		Response r = new Response("joinGame");
		if (currentGame != null) {
			r.addParam("success", false);
			r.addParam("error", "User is already in game " + currentGame.getId());
		}else if (!Game.gameExists(id)) {
			r.addParam("success", false);
			r.addParam("error", "Game " + id + " does not exist");
		}else {
			currentGame = Game.getGame(id);
			if (currentGame.addUser(this) == true) {
				r.addParam("success", true);
			}else {
				r.addParam("success", false);
				r.addParam("error", "Game " + id + " is full");
				currentGame = null;
			}
		}
		r.send(session);
		
	}
	
	private void leaveGame() {
		Response r = new Response("joinGame");
		if (currentGame == null) {
			r.addParam("success", false);
			r.addParam("error", "User is not in a game");
		}else {
			currentGame.removeUser(this);
			currentGame = null;
			r.addParam("success", true);
		}
		r.send(session);
	}
	
	private void bet(int amount) {
		
	}
	
	private void call() {
		
	}
	
	private void check() {
		
	}
	
	private void getGameInfo() {
		
	}
	
	public void disconnect() {
		
	}

	public Session getSession() {
		return session;
	}
	
}
