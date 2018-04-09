package collectionconnection;

import java.util.Date;

public class RealTimeNotification extends Notification {

	@Override
	public boolean isWithinTimePeriod(Date from) {
		return false;
	
	}
	
	@Override
	public String getContent(NotificationText text) {
		assert text != null : "NotificationText shouldn't be null";
		return text.getNotificationText();
	}
	

}
