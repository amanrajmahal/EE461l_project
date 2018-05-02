package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class SettingsServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Profile profile = ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		String type = request.getParameter("type");
		profile.changeNotificationType(type);
		boolean sendCollections = request.getParameter("getCollections") != null;
		boolean sendPhotos = request.getParameter("getPhotos") != null;
		boolean sendFollowers = request.getParameter("getFollowers") != null;
		profile.changeNotificationSettings(sendCollections, sendPhotos, sendFollowers);
		ofy().save().entity(profile).now();
		response.sendRedirect("/settings.jsp");
	}

}
