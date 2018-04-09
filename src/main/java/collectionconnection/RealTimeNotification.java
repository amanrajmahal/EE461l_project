package collectionconnection;

public class RealTimeNotification extends Notification {
	
	@Override
	public String getContent(NotificationText text) {
		assert text != null : "NotificationText shouldn't be null";
		return text.getNotificationText();
	}
	

}
