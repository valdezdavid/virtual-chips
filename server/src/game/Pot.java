//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
package game;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import server.Response;

public class Pot {

	Map<User, Integer> chips = new HashMap<User, Integer>();
	
	
	public void placeBet(User u, int amount) {
		Integer prevAmount = chips.get(u);
		if (prevAmount == null) {
			prevAmount = 0;
		}
		chips.put(u, amount + prevAmount);
	}
	
	public boolean isEmpty() {
		return chips.isEmpty();
	}
	
	public void checkRedeem() {
		User lastUser = null;
		for (User u : chips.keySet()) {
			if (!u.isFolded()) {
				if (lastUser == null) {
					lastUser = u;
				}else {
					return;
				}
			}		
		}
		redeem(lastUser);
	}
	
	public void redeem(User user) {
		if (!chips.containsKey(user)) {
			return;
		}
		int max = chips.get(user);
		int sum = 0;
		for (User u : chips.keySet()) {
			int userChips = chips.get(u);
			int amount = Math.min(userChips, max);
			sum += amount;
			if (userChips-amount == 0) {
				chips.remove(u);
			}else {
				chips.put(u, userChips-amount);
			}			
		}
		user.setChips(user.getChips()+sum);
		Response r = new Response("win");
		r.addParam("userId", user.getId());
		r.addParam("amount", sum);
		user.getCurrentGame().sendResponseToAll(r);
	}
	
	public int getPotSize() {
		int sum = 0;
		for (User u : chips.keySet()) {
			sum += chips.get(u);		
		}
		return sum;
	}
	
	public Set<User> getUsersInPot(){
		Set<User> users = new HashSet<User>();
		for (User u : chips.keySet()) {
			if (!u.isFolded()) {
				users.add(u);
			}		
		}
		
		return users;
	}
	
	
	
}
