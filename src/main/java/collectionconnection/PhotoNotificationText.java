package collectionconnection;

import com.googlecode.objectify.annotation.Subclass;

@Subclass
public class PhotoNotificationText extends NotificationText {
	private String user;
	private String collectionName;
	
	private PhotoNotificationText() {}
	
	public PhotoNotificationText(String user, String collectionName) {
		super();
		this.user = user;
		this.collectionName = collectionName;
	}
	
	@Override
	public String getNotificationText() {
		return String.format("%s has uploaded a new photo in collection \"%s\"", 
				user, collectionName);
	}
	

}
