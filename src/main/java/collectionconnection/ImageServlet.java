package collectionconnection;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class ImageServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
	}
	
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String collectionName = req.getParameter("collectionName");
		List<BlobKey> blobKeys = blobs.get("myFile");
		if(blobKeys == null || blobKeys.size() == 0)
		{
			res.sendRedirect("/collectionPage.jsp?collectionName="+collectionName);
		}
		else
		{
			ofy().clear();
			Profile profile = ofy().load().type(Profile.class).filter("actualUser", user).first().now();
			if(profile != null)
			{
				profile.addCollection(collectionName);
				profile.addPhoto(collectionName, "PhotoNameTest",  blobKeys.get(0).getKeyString());
				//save the new entity
				ofy().clear();
				ofy().save().entity(profile).now();
			}
			res.sendRedirect("/collectionPage.jsp?targetProfile="+profile.getUsername()+"&collectionName="+collectionName);
		}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
		blobstoreService.serve(blobKey, resp);
	}

}
