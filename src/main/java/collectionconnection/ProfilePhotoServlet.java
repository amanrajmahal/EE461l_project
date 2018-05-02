package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class ProfilePhotoServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
	}
	
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		System.out.println("PROFILEPHOTO SERVLET");
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
		String username = req.getParameter("username");
		List<BlobKey> blobKeys = blobs.get("myFile");
		Profile profile = ofy().load().type(Profile.class).filter("username", username).first().now();
		if(profile.getProfilePhoto().getBlobKey() != null)
		{
			blobstoreService.delete(new BlobKey(profile.getProfilePhoto().getBlobKey()));
		}
		profile.setProfilePhoto(blobKeys.get(0).getKeyString());
		ofy().save().entity(profile).now();
		resp.sendRedirect("/profilePage.jsp?username=" + username);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
