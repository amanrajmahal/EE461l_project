package collectionconnection;

import java.util.*;

import com.google.appengine.api.users.User;

public class Collection {
	private String collectionName;
	private ArrayList<Photo> photos;
	private ArrayList<Comment> comments;
	
	private Collection() {}
	
	public Collection(String collectionName)
	{
		this.collectionName = collectionName;
		this.photos = new ArrayList<Photo>();
		this.comments = new ArrayList<Comment>();
	}
	
	public void addPhoto(String name, String blobKey)
	{
		photos.add(new Photo(name, blobKey));
	}
	
	public void addComment(User user, String comment) {
		comments.add(new Comment(user, comment));
	}
	
	public ArrayList<Photo> getPhotos()
	{
		return photos;
	}
	
	public String getCollectionName()
	{
		return collectionName;
	}
}
