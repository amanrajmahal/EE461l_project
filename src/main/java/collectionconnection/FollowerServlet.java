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
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String username = req.getParameter("username");
		
		//ofy().clear();
		Profile myProfile = ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		//ofy().clear();
		Profile profile = ofy().load().type(Profile.class).filter("username", username).first().now();
		
		if(myProfile != null && profile != null && !myProfile.equals(profile))
		{
			Set<Ref<Follower>> followers = profile.getFollowers();
			Ref<Follower> follower = Ref.create(myProfile);
			if(followers.contains(follower))
			{
				profile.removeFollower(follower);
			}
			else
			{
				profile.addFollower(follower);
			}
			//System.out.println(follower.isLoaded());
			System.out.println("Followers @ servlet: " + followers);
			//ofy().clear();
			ofy().save().entity(profile).now();
		}
		resp.sendRedirect("/profilePage.jsp?username=" + profile.getUsername());
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
