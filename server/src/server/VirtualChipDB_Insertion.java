package server;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class VirtualChipDB_Insertion {
	private static String DB_user = "root";
	private static String DB_password = "root";
//
//	public static void main (String[] args) {
//		registerNewUser("rohan", "passcode");
//		loginUser("rohan", "passcode");
//		incrementGamesPlayed("rohan");
//		incrementWinnings("rohan", 25);
//		incrementLosses("rohan", 5);
//		incrementRoundsPlayed("rohan");
//		incrementRoundsWon("rohan");
//		
//	}//basic main method for actually executing queries
//

	public static boolean registerNewUser(String username, String password) {
		
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean alreadyExists = false;

		//check if name exists
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				String returned_username = rs.getString("username");
				if (!(returned_username.equals(""))) {
					//username exists
					alreadyExists = true;
				}
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		
		//now insert into table if name doesnt exist
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			if (!alreadyExists) {//username does not exist
				ps = conn.prepareStatement("INSERT INTO Users (username, password_str, gamesPlayed, winnings, losses, roundsPlayed, roundsWon) VALUES (?, ?, ?, ?, ?, ?, ?);");
				ps.setString(1, username); // set first variable in prepared statement
				ps.setString(2, password);
				ps.setInt(3, 0);
				ps.setInt(4, 0);
				ps.setInt(5, 0);
				ps.setInt(6, 0);
				ps.setInt(7, 0);
				ps.executeUpdate();
			}	
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		//TESTING - checking table values
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				String returned_username = rs.getString("username");
				System.out.println("Returned username: " + returned_username); 
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		return !alreadyExists;
		
	} //end of registerUser
	
	
	public static boolean loginUser(String username, String password) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean correctLogin = false;

		//check if name exists
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=? AND password_str=?;");
			ps.setString(1, username);
			ps.setString(2, password);
			rs = ps.executeQuery();
			while (rs.next()) {
				String returned_username = rs.getString("username");
				if (!(returned_username.equals(""))) {
					//if we got a user that means it was the right password
					System.out.println("Login is valid");
					correctLogin = true;
				}
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		if (!correctLogin) {
			System.out.println("incorrect login.");
		}
		return correctLogin;
	} //end of loginUser
	
	
	
	/*GETTERS AND SETTERS*/
	
	public static void incrementGamesPlayed(String username) {
		
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int currentGamesPlayed = 0;
	
			
			
		//first get the current games played	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				currentGamesPlayed = rs.getInt("gamesPlayed");
				System.out.println("currentGamesPlayed: " + currentGamesPlayed); 
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		currentGamesPlayed++;
		//now increment gamesplayed
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			ps = conn.prepareStatement("UPDATE Users SET gamesPlayed=? WHERE username=?");
			ps.setInt(1, currentGamesPlayed);
			ps.setString(2, username); // set first variable in prepared statement
			ps.executeUpdate();		
				
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		System.out.println("gamesPlayed: " + getGamesPlayed(username));
		
	}
	
	public static int getGamesPlayed(String username) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				int gamesPlayed = rs.getInt("gamesPlayed");
				return gamesPlayed;
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		return -1; //value not found from given username				
	}

	
	public static void incrementWinnings(String username, int winAmount) {
		
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int winnings = 0;
	
		
		//first get the current games played	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				winnings = rs.getInt("winnings");
				System.out.println("winnings: " + winnings); 
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		winnings = winnings + winAmount;
		//now increment win amount
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("UPDATE Users SET winnings=? WHERE username=?");
			ps.setInt(1, winnings);
			ps.setString(2, username); // set first variable in prepared statement
			ps.executeUpdate();

		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		System.out.println("Winnings: " + winnings);
			
		
	}
	
	public static int getWinnings(String username) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				int winnings = rs.getInt("winnings");
				return winnings;
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		return -1; //value not found from given username		
	}

	
	public static void incrementLosses(String username, int lossAmount) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int losses = 0;
	
		//first get the current games played	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				losses = rs.getInt("losses");
				System.out.println("losses: " + losses); 
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		losses = losses + lossAmount;
		//now increment loss amount
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("UPDATE Users SET losses=? WHERE username=?");
			ps.setInt(1, losses);
			ps.setString(2, username); // set first variable in prepared statement
			ps.executeUpdate();						
				
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		System.out.println("losses: " + getLosses(username));
			
	} //end of incrementLosses function
	
	public static int getLosses(String username) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				int losses = rs.getInt("losses");
				return losses;
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		return -1; //value not found from given username
	}
	
	
	public static void incrementRoundsPlayed(String username) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int currentRoundsPlayed = 0;
	
			
			
		//first get the current games played	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				currentRoundsPlayed = rs.getInt("roundsPlayed");
				System.out.println("currentRoundsPlayed: " + currentRoundsPlayed); 
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		currentRoundsPlayed++;
		//now increment gamesplayed
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			ps = conn.prepareStatement("UPDATE Users SET roundsPlayed=? WHERE username=?");
			ps.setInt(1, currentRoundsPlayed);
			ps.setString(2, username); // set first variable in prepared statement
			ps.executeUpdate();		
				
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		System.out.println("currentRoundsPlayed: " + getRoundsPlayed(username));
			
	
	}

	public static int getRoundsPlayed(String username) {
		
		
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				int currentRoundsPlayed = rs.getInt("roundsPlayed");
				return currentRoundsPlayed;
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		return -1; //value not found from given username
		
	}
	
	
	public static void incrementRoundsWon(String username) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int currentRoundsWon = 0;
	
			
			
		//first get the current games played	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				currentRoundsWon = rs.getInt("roundsWon");
				System.out.println("currentRoundsWon: " + currentRoundsWon); 
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		currentRoundsWon++;
		//now increment gamesplayed
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			ps = conn.prepareStatement("UPDATE Users SET roundsWon=? WHERE username=?");
			ps.setInt(1, currentRoundsWon);
			ps.setString(2, username); // set first variable in prepared statement
			ps.executeUpdate();		
				
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		
		//TESTING - checking if this worked
		System.out.println("currentRoundsWon: " + getRoundsWon(username));
	
	}
	
	
	public static int getRoundsWon(String username) {
		
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/VirtualChipDB?user="+DB_user+"&password="+DB_password+"&useSSL=false");
			st = conn.createStatement();
			//check if the user already exists
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, username);
			rs = ps.executeQuery();
			while (rs.next()) {
				int currentRoundsWon = rs.getInt("roundsWon");
				return currentRoundsWon;
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	
	return -1; //value not found from given username
		
		
	}


	
	
}
