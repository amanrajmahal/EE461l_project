package collectionconnection;

public class PhotoNotificationText implements NotificationText {
	private String user;
	private String photoName;
	
	public PhotoNotificationText(String user, String photoName) {
		this.user = user;
		this.photoName = photoName;
	}
	
	@Override
	public String getNotificationText() {
		return user + " has uploaded a new photo named " + photoName;
	}
	

}
