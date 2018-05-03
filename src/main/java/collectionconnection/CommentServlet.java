package collectionconnection;
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class CommentServlet extends HttpServlet {
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
		String comment = req.getParameter("comment");
		//the logged in user is commenting on this profile and collection
		String username = req.getParameter("username");
		String collection = req.getParameter("collection");
		//ofy().clear();
		Profile profile = ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now();
		if(profile != null)
		{
			ArrayList<Collection> collections = profile.getCollections();
			for(Collection profileCollection : collections)
			{
				//the collection we are looking for
				if(profileCollection.getCollectionName().equals(collection))
				{
					profileCollection.addComment(comment, user);
				}
			}
			//ofy().clear();
			ofy().save().entity(profile).now();
		}
		resp.sendRedirect("/collectionPage.jsp?username=" + username + "&collection=" + collection);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
