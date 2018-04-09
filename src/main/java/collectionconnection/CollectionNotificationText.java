package collectionconnection;

import com.google.appengine.api.users.User;

public class CollectionNotificationText implements NotificationText {
	private String user;
	private String collectionName;
	
	public CollectionNotificationText(String user, String collectionName) {
		this.user = user;
		this.collectionName = collectionName;
	}
	
	@Override
	public String getNotificationText() {
		return user + " added a new collection named " + collectionName;
	}

}
