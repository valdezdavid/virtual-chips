package server;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.websocket.Session;

import com.google.gson.Gson;

public class Response {
	private String event;
	private Map<String, Object> params = new HashMap<String, Object>();
	
	public Response(String event) {
		this.event = event;
	}
	
	public String getEvent() {
		return event;
	}

	public void setCommand(String event) {
		this.event = event;
	}

	public Map<String, Object> getParams() {
		return params;
	}

	public void setParams(Map<String, Object> params) {
		this.params = params;
	}
	
	public void addParam(String key, Object value) {
		params.put(key, value);
	}
	
	public void send(Session session) {
		String json = new Gson().toJson(this);
		try {
			session.getBasicRemote().sendText(json);
		} catch (IOException e) {
			System.out.println("ioe: " + e.getMessage());
		}
	}
}
