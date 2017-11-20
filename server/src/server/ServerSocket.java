//Stiven Deleur, Anubhav Garg, Valerie Gomez, David Valdez, Rohan Shastri
package server;

import java.util.HashMap;
import java.util.Map;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.google.gson.Gson;

import game.User;

@ServerEndpoint(value = "/pokerchip")
public class ServerSocket {
	
	private static Map<Session, User> users = new HashMap<>();
	@OnOpen
	public void open(Session session) {
		System.out.println("Client Connected");
		users.put(session, new User(session));
	}
	
	@SuppressWarnings("unchecked")
	@OnMessage
	public void onMessage(String message, Session session) {
		System.out.println(message);
		Map<String, Object> messageJsonObject = new Gson().fromJson(message, Map.class);
		String command = messageJsonObject.get("command").toString();
		Map<String, Object> params = (Map<String, Object>)messageJsonObject.get("params");
		users.get(session).executeCommand(command, params);
	}
	
	@OnClose
	public void close(Session session) {
		System.out.println("Client Disconnected");
		users.remove(session);
	}
	
	@OnError
	public void onError(Throwable error) {
		System.out.println("ServerSocket Error: " + error);
	}
}