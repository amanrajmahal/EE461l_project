package collectionconnection;

public class CollectionNotificationText implements NotificationText {
	private String user;
	private String collectionName;
	
	public CollectionNotificationText(String user, String collectionName) {
		this.user = user;
		this.collectionName = collectionName;
	}
	
	@Override
	public String getNotificationText() {
		return String.format("%s has added a new collection \"%s\"", user, collectionName);
	}

}
