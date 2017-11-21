//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
package game;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.websocket.Session;

import server.Response;
import server.VirtualChipDB_Insertion;

public class User {
	static private Map<Integer, User> users = new HashMap<Integer, User>();
	private Session session;
	private Game currentGame;
	public Game getCurrentGame() {
		return currentGame;
	}

	private int id;
	private String username;
	private boolean authenticated = false;
	private int currentBet = 0;
	private int chips = 100;
	
	private boolean folded = false;
	
	
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
			int buyIn = Integer.valueOf((String)params.get("buyIn"));
			int smallBlind = Integer.valueOf((String)params.get("smallBlind"));
			int bigBlind = Integer.valueOf((String)params.get("bigBlind"));
			int numPlayers = Integer.valueOf((String)params.get("numPlayers"));
			startGame(buyIn, smallBlind, bigBlind, numPlayers);
			break;
		case "joinGame":
			int id = Integer.valueOf((String)params.get("id"));
			joinGame(id);
			break;
		case "leaveGame":
			leaveGame();
			break;
		case "bet":
			bet(Integer.valueOf((String)params.get("amount")));
			break;
		case "check":
			check();
			break;
		case "fold":
			fold();
			break;
		case "chooseWinner":
			currentGame.getCurrentHand().getPot().redeem(users.get(Integer.valueOf((String)params.get("userId"))));
			currentGame.getCurrentHand().finishHand();
			break;
		}
	}
	
	public int getCurrentBet() {
		return currentBet;
	}

	public boolean canMakeMove() {
		return chips > 0;
	}
	
	public boolean isFolded() {
		return folded;
	}

	private void login(String username, String password) {
		// TODO check database
		if (VirtualChipDB_Insertion.loginUser(username, password)) {
			this.username = username;
			authenticated = true;
			Response r = new Response("login");
			r.addParam("success", true);
			r.send(this);
		} else {
			Response r = new Response("login");
			r.addParam("success", false);
			r.send(this);
		}
	}
	
	private void register(String username, String password) {
		// TODO add to database
		if (VirtualChipDB_Insertion.registerNewUser(username, password)) {
			this.username = username;
			authenticated = true;
			Response r = new Response("register");
			r.addParam("success", true);
			r.send(this);
		} else {
			Response r = new Response("login");
			r.addParam("success", false);
			r.send(this);
		}
	}
	
	private void startGame(int buyIn, int smallBlind, int bigBlind, int numPlayers) {
		currentGame = new Game(this, buyIn, smallBlind, bigBlind, numPlayers);
		Response r = new Response("startGame");
		r.addParam("success", true);
		r.addParam("id", currentGame.getId());
		r.addParam("userId", id);
		r.send(this);
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
				r.addParam("userId", id);
			}else {
				r.addParam("success", false);
				r.addParam("error", "Game " + id + " is full");
				currentGame = null;
			}
		}
		r.send(this);
		if (currentGame != null) {
			currentGame.startGame();
		}
	}
	
	public String getUsername() {
		return username == null ? String.valueOf(id) : username;
	}

	public int getChips() {
		return chips;
	}
	

	public void setChips(int chips) {
		this.chips = chips;
	}

	public int getId() {
		return id;
	}

	private void leaveGame() {
		Response r = new Response("leaveGame");
		if (currentGame == null) {
			r.addParam("success", false);
			r.addParam("error", "User is not in a game");
		}else {
			currentGame.removeUser(this);
			currentGame = null;
			r.addParam("success", true);
		}
		r.send(this);
	}
	
	public void bet(int amount) {
		amount = Math.min(amount, chips);
		currentBet += amount;
		chips -= amount;
		currentGame.getCurrentHand().placeBet(this, amount);	
		Response r = new Response("bet");
		r.addParam("userId", id);
		r.addParam("amount", amount);
		currentGame.sendResponseToAll(r);
		currentGame.getCurrentHand().goToNextPlayer();
	}
	public void betBlind(int amount) {
		amount = Math.min(amount, chips);
		currentBet += amount;
		chips -= amount;
		currentGame.getCurrentHand().placeBet(this, amount);	
	}
	
	public void resetCurrentBet() {
		currentBet = 0;
	}
	
	public void resetFolded() {
		folded = false;
	}

	private void check() {
		Response r = new Response("check");
		r.addParam("userId", id);
		currentGame.sendResponseToAll(r);
		currentGame.getCurrentHand().goToNextPlayer();
	}
	
	private void fold() {
		folded = true;
		Response r = new Response("fold");
		r.addParam("userId", id);
		currentGame.sendResponseToAll(r);
		currentGame.getCurrentHand().goToNextPlayer();

	}

	public Session getSession() {
		return session;
	}
	
	public String toString() {
		return String.valueOf(id);
	}
	
}
