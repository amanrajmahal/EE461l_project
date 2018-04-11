package collectionconnection;

import java.util.Calendar;
import java.util.Date;
import static com.googlecode.objectify.ObjectifyService.ofy;


public class CustomNotification extends Notification {
	int numHours;
	
	public CustomNotification() {
		super();
		this.numHours = 1;
	}
	
	public void setNumHours(int hours) {
		numHours = hours;
	}
	
	@Override
	public String getContent(NotificationText text) {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.HOUR, -1 * numHours);
		Date timeBack = cal.getTime();
		if (includeComments()) {
			//List<Comment> comments = ofy().load().type(Comment.class).filter("date >=", timeBack).list();
			//Collections.sort(comments);
			//getComments
		}
		if (includeCollections()) {
			//List<Collection>
			//getCollections
		}
		
		return null;
	}
	

}
