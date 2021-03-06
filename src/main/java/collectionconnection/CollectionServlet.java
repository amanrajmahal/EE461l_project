package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class CollectionServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String username = req.getParameter("username");
		String collection = req.getParameter("collection");
		Profile profile = ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now();
		
		if(profile != null && collection != null && collection.length() > 0)
		{
			profile.addCollection(collection);
			ofy().save().entity(profile).now();
			res.sendRedirect("/collectionPage.jsp?username=" + username + "&collection="+  collection);
		}
		else
		{
			res.sendRedirect(req.getHeader("referer"));
		}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

	}

}
