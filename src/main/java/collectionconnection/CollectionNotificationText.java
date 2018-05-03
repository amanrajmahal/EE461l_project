package collectionconnection;

import com.googlecode.objectify.annotation.Subclass;

@Subclass
@SuppressWarnings("unused")
public class CollectionNotificationText extends NotificationText {
	private String user;
	private String collectionName;
	
	private CollectionNotificationText() {}
	
	public CollectionNotificationText(String user, String collectionName) {
		super();
		this.user = user;
		this.collectionName = collectionName;
	}
	
	@Override
	public String getNotificationText() {
		return String.format("%s has added a new collection \"%s\"", user, collectionName);
	}

}
