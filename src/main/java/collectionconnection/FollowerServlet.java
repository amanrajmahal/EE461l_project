package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.Ref;

public class FollowerServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String profileToAdd = req.getParameter("profileToAdd");
		
		ofy().clear();
		Profile userProfile = ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		ofy().clear();
		Profile userToAdd = ofy().load().type(Profile.class).filter("username", profileToAdd).first().now();
		
		if(userProfile != null && userToAdd != null && !userProfile.equals(userToAdd))
		{
			Set<Ref<Follower>> followers = userToAdd.getFollowers();
			if(followers.contains(Ref.create(userProfile)))
			{
				userToAdd.removeFollower(Ref.create(userProfile));
			}
			else
			{
				userToAdd.addFollower(Ref.create(userProfile));
			}
			System.out.println(followers);
			ofy().clear();
			ofy().save().entity(userToAdd).now();
		}
		
		resp.sendRedirect("/profilePage.jsp?targetProfile=" + userToAdd.getUsername());
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
