package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class CollectionServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String targetUsername = req.getParameter("username");
		String collectionName = req.getParameter("collection");
		String currentProfile = req.getParameter("currentProfile");
		
		ofy().clear();
		Profile profile = ofy().load().type(Profile.class).filter("username", targetUsername).first().now();
		
		if(profile != null && collectionName != null && !collectionName.isEmpty())
		{
			profile.addCollection(collectionName);
			
			ofy().clear();
			ofy().save().entity(profile).now();
		}
		
		res.sendRedirect("/profilePage.jsp?targetProfile=" + currentProfile);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

	}

}
