package collectionconnection;

import java.io.IOException;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.util.List;

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
			InternetAddress[] emails = p.getFollowerEmails();
		}
	}
}