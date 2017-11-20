package server;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.websocket.Session;

import com.google.gson.Gson;

import game.User;

public class Response {
	private String event;
	private Map<String, String> params = new HashMap<String, String>();
	
	public Response(String event) {
		this.event = event;
	}
	
	public String getEvent() {
		return event;
	}

	public Map<String, String> getParams() {
		return params;
	}

	public void setParams(Map<String, String> params) {
		this.params = params;
	}
	
	public void addParam(String key, Object value) {
		params.put(key, String.valueOf(value));
	}
	
	public void send(User user) {
		String json = new Gson().toJson(this);
		try {
			user.getSession().getBasicRemote().sendText(json);
		} catch (IOException e) {
			System.out.println("ioe: " + e.getMessage());
		}
	}
}
