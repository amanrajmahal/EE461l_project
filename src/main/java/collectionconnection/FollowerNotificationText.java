package collectionconnection;

import com.googlecode.objectify.annotation.Subclass;

@Subclass
@SuppressWarnings("unused")
public class FollowerNotificationText extends NotificationText {
	private String user;
	
	private FollowerNotificationText() {}
	
	public FollowerNotificationText(String user) {
		super();
		this.user = user;
	}
	
	@Override
	public String getNotificationText() {
		return String.format("%s has followed you", user); 
		
	}

}
