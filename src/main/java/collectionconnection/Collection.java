package collectionconnection;

import java.util.*;
import com.google.appengine.api.users.User;

import collectionconnection.Collection;
@SuppressWarnings("unused")
public class Collection {
	private String collectionName;
	private ArrayList<Photo> photos = new ArrayList<>();
	private ArrayList<Comment> comments = new ArrayList<>();
	private int commentId = 0;
	
	private Collection() {}
	
	public Collection(String collectionName)
	{
		this.collectionName = collectionName;
		this.photos = new ArrayList<Photo>();
		this.comments = new ArrayList<Comment>();
		this.commentId = 0;
	}
	
	public void addPhoto(String name, String blobKey)
	{
		photos.add(new Photo(name, blobKey));
	}

	public void addComment(String comment, User user)
	{
		commentId++;
		comments.add(new Comment(user, comment, commentId));
	}
	
	public ArrayList<Photo> getPhotos()
	{
		return photos;
	}
	
	public ArrayList<Comment> getComments()
	{
		return comments;
	}
	
	public String getCollectionName()
	{
		return collectionName;
	}
}
