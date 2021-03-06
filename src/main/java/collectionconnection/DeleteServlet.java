package collectionconnection;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class DeleteServlet extends HttpServlet {
	static {
		ObjectifyService.register(Profile.class);
	}
	
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String command = req.getParameter("command");
		String username = req.getParameter("username");
		String collectionname = req.getParameter("collection");
		Profile profile = ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now();
		ArrayList<Collection> collections = profile.getCollections();
		
		System.out.println("TEST");
		
		switch(command)
		{
			case "profile":
				for(Collection collection : collections)
				{
					for(Photo photo : collection.getPhotos())
					{
						blobstoreService.delete(new BlobKey(photo.getBlobKey()));
					}
				}
				collections.clear();
				ofy().delete().entity(profile);
				resp.sendRedirect("/welcomePage.jsp");
				break;
			case "collection":
				Collection collectionToRemove = null;
				for(Collection collection : collections)
				{
					if(collection.getCollectionName().equals(collectionname))
					{
						ArrayList<Photo> photos = collection.getPhotos();
						for(Photo photo : photos)
						{
							blobstoreService.delete(new BlobKey(photo.getBlobKey()));
						}
						photos.clear();
						collectionToRemove = collection;
						break;
					}
				}
				collections.remove(collectionToRemove);
				ofy().save().entity(profile).now();
				resp.sendRedirect("/profilePage.jsp?username=" + username);
				break;
			case "photo":
				System.out.println("Photo");
				String photoKey = req.getParameter("photo");
				System.out.println("Passed key:" + photoKey);
				for(Collection collection : collections)
				{
					if(collection.getCollectionName().equals(collectionname))
					{
						ArrayList<Photo> photos = collection.getPhotos();
						Photo photoToRemove = null;
						for(Photo photo : photos)
						{
							System.out.println(photo.getBlobKey());
							if(photo.getBlobKey().equals(photoKey))
							{
								//System.out.println("WUT");
								photoToRemove = photo;
								blobstoreService.delete(new BlobKey(photo.getBlobKey()));
							}
						}
						photos.remove(photoToRemove);
						break;
					}
				}
				ofy().save().entity(profile).now();
				resp.sendRedirect("collectionPage.jsp?username=" + username + "&collection=" + collectionname);
				break;
			case "comment":
				int commentId = Integer.parseInt(req.getParameter("commentId"));
				for(Collection collection : collections)
				{
					if(collection.getCollectionName().equals(collectionname))
					{
						ArrayList<Comment> comments = collection.getComments();
						Comment commentToRemove = null;
						for(Comment comment : comments)
						{
							if(comment.getCommentId() == commentId)
							{
								commentToRemove = comment;
								break;
							}
						}
						comments.remove(commentToRemove);
					}
				}
				ofy().save().entity(profile).now();
				resp.sendRedirect("collectionPage.jsp?username=" + username + "&collection=" + collectionname);
				break;
			default: 
				resp.sendRedirect("/profilePage.jsp?username=" + username);
				break;
		}
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
	}
}
