package collectionconnection;

import java.util.*;

import collectionconnection.Collection;

public class Collection {
	private String collectionName;
	private ArrayList<Photo> photos = new ArrayList<>();
	
	private Collection() {}
	
	public Collection(String collectionName)
	{
		this.collectionName = collectionName;
		this.photos = new ArrayList<Photo>();
	}
	
	public void addPhoto(String name, String blobKey)
	{
		//checkPhotos();
		photos.add(new Photo(name, blobKey));
	}
	
	public ArrayList<Photo> getPhotos()
	{
		//checkPhotos();
		return photos;
	}
	
	public String getCollectionName()
	{
		return collectionName;
	}
	
	/*private void checkPhotos()
	{
    	if(photos == null) this.photos = new ArrayList<Photo>();
	}*/
}
