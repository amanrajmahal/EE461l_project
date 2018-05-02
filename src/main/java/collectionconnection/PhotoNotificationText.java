package collectionconnection;

import com.googlecode.objectify.annotation.Subclass;

@Subclass
public class PhotoNotificationText extends NotificationText {
	private String user;
	private String photoName;
	private String collectionName;
	
	private PhotoNotificationText() {}
	
	public PhotoNotificationText(String user, String photoName, String collectionName) {
		super();
		this.user = user;
		this.photoName = photoName;
		this.collectionName = collectionName;
	}
	
	@Override
	public String getNotificationText() {
		return String.format("%s has uploaded a new photo \"%s\" in collection \"%s\"", 
				user, photoName, collectionName);
	}
	

}
