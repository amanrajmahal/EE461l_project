package collectionconnection;
import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class ProfileServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String username = req.getParameter("username");
		Profile profile = ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now();
		if(username != null && username.length() == 0)
		{
			resp.sendRedirect(req.getHeader("referer"));
		}
		else if(profile == null) {
			ofy().save().entity(new Profile(user, username)).now();
			resp.sendRedirect("/profilePage.jsp?username=" + username);
		}
		else
		{
			resp.sendRedirect("/welcomePage.jsp?alert=true");
		}
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
