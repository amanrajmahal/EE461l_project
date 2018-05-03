package collectionconnection;

import java.io.IOException;

import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.util.*;

@SuppressWarnings("serial")
public class CronJobServlet extends HttpServlet { 
	static {
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		List<Profile> profiles = ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).list();
		for (Profile p : profiles) {
			if (p.getNotificationType() == NotificationType.DAILY) {
				p.alert(null);
			}
			ofy().save().entity(p).now();
		}
	}
}