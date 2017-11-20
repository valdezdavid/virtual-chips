package game;

import java.util.HashMap;
import java.util.Map;

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
	
	public int redeem(User user) {
		if (!chips.containsKey(user)) {
			return 0;
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
		return sum;
	}
	
	
	
}
