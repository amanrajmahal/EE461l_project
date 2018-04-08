package collectionconnection;

import java.util.*;

public class Collection {
	private String collectionName;
	private ArrayList<Photo> photos;
	
	private Collection() {}
	
	public Collection(String collectionName)
	{
		this.collectionName = collectionName;
		this.photos = new ArrayList<Photo>();
	}
	
	public void addPhoto(String name, String blobKey)
	{
		photos.add(new Photo(name, blobKey));
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
