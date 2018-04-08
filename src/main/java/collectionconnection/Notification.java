package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.googlecode.objectify.ObjectifyService;

public abstract class Notification {

	public void alert() {
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);

		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.HOUR, -30);
		Date yesterdayTime = cal.getTime();

		/*ObjectifyService.register(BlogPost.class);
		List<BlogPost> blogposts = ObjectifyService.ofy().load().type(BlogPost.class).list();
		Collections.sort(blogposts);
		if (!blogposts.isEmpty() && isWithin24Hours(yesterdayTime, blogposts.get(0).getDate())) {
			String body = getBody(yesterdayTime, blogposts);
			try {
				ObjectifyService.register(Email.class);
				Message msg = new MimeMessage(session);
				msg.setFrom(new InternetAddress("admin@collectionconnection.appspotmail.com",
						"Collection Connection Digest"));
				List<Email> emails = ofy().load().type(Email.class).list();
				InternetAddress[] addresses = new InternetAddress[emails.size()];
				for (int i = 0; i < emails.size(); i++)
					addresses[i] = emails.get(i).getEmail();
				msg.addRecipients(Message.RecipientType.BCC, addresses);
				msg.setSubject("Daily Digest");
				msg.setText(body);
				Transport.send(msg);
			} catch (Exception e) {
			}
		}*/
	}
	
	public abstract boolean isWithinTimePeriod(Date from);
	
	public abstract String getContent(Date from, boolean getComments, boolean getCollections);
}
