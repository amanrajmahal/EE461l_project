package collectionconnection;

import java.util.Calendar;
import java.util.Date;

public abstract class NotificationText implements Comparable<NotificationText> {
	private Date date;
	
	public NotificationText() {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.HOUR, -5);
		date = cal.getTime();
	}
	
	public Date getDate() {
		return date;
	}
	
	public abstract String getNotificationText();
	
	@Override
	public int compareTo(NotificationText other) {
		if (date.after(other.date)) {
			return 1;
		} else if (date.before(other.date)) {
			return -1;
		}
		return 0;
	}
}
