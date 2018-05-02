package collectionconnection;

import java.io.IOException;
import java.text.DateFormat;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.util.List;
import java.util.TreeSet;

public class CronJobServlet extends HttpServlet { 
	//private static final Logger log = Logger.getLogger(BlogPostServlet.class.getName()); 
	static {
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			//log.info("Cron job received");
			sendMail();
		} catch (Exception e) {}
	}
	
	private void sendMail() throws AddressException{
		ObjectifyService.register(Profile.class);
		List<Profile> profiles = ofy().load().type(Profile.class).list();
		for (Profile p : profiles) {
			InternetAddress[] emails = p.getFollowerEmails(false);
			Notification.alert(getLogString(p.getNotificationLog()), emails);	
		}
	}
	
	public String getLogString(TreeSet<NotificationText> log) {
		StringBuilder str = new StringBuilder();
		for (NotificationText text : log) {
			String date = DateFormat.getDateInstance(DateFormat.SHORT).format(text.getDate());
			str.append(date).append(" ").append(text.getNotificationText()).append("\n");
		}
		return str.toString();
	}
}