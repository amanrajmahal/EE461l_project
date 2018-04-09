package collectionconnection;

import java.util.Calendar;
import java.util.Date;
import static com.googlecode.objectify.ObjectifyService.ofy;


public class CustomNotification extends Notification {

	@Override
	public boolean isWithinTimePeriod(Date from) {
		// use numHoursBack here
		return false;
	}

	@Override
	public String getContent() {
		NotificationOptions options = getOptions();
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.HOUR, -1 * options.getNumHours());
		Date timeBack = cal.getTime();
		if (options.getComments()) {
			//List<Comment> comments = ofy().load().type(Comment.class).filter("date >=", timeBack).list();
			//Collections.sort(comments);
			//getComments
		}
		if (options.getCollections()) {
			//List<Collection>
			//getCollections
		}
		
		return null;
	}
	

}
