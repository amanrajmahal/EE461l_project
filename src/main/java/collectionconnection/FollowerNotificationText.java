package collectionconnection;

public class FollowerNotificationText extends NotificationText {
	private String user;
	
	public FollowerNotificationText(String user) {
		super();
		this.user = user;
	}
	
	@Override
	public String getNotificationText() {
		return String.format("%s has followed you", user); 
		
	}

}
