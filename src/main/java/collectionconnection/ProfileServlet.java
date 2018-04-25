package collectionconnection;
import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class ProfileServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String username = req.getParameter("username");
		Profile profile = ofy().load().type(Profile.class).filter("username", username).first().now();
		if(profile == null) ofy().save().entity(new Profile(user, username)).now();
		resp.sendRedirect("/welcomePage.jsp");
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
