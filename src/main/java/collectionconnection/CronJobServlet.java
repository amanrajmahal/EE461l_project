package collectionconnection;

import java.io.IOException;
import java.text.DateFormat;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.util.List;
import java.util.Properties;
import java.util.TreeSet;

public class CronJobServlet extends HttpServlet { 
	//private static final Logger log = Logger.getLogger(BlogPostServlet.class.getName()); 
	
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
			alert(getLogString(p.getNotificationLog()), emails);	
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
	
	public void alert(String text, InternetAddress[] emails) {	
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress("admin@collectionconnection.appspotmail.com","CollectionConnection Digest"));
			msg.addRecipients(Message.RecipientType.BCC, emails);
			msg.setSubject("Notifications from CollectionConnection");
			msg.setText(text);
			Transport.send(msg);	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}