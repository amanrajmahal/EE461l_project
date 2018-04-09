package collectionconnection;
import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.*;

@Entity
public class Profile implements Comparable<Profile>, Follower, Subject {
    @Id Long id;
    @Index User actualUser;
    
    private String firstName;
    private String lastName;
    private Date date;
    private ArrayList<Collection> collections;
    private Set<Follower> followers;
    private Notification notificationStyle;
    
    private Profile() {}
    public Profile(User user, String firstName, String lastName) { 
    	//this.user = Key.create(ProfileKey.class, user.getNickname());
    	this.actualUser = user;
    	this.firstName = firstName;
    	this.lastName = lastName;
        this.date = new Date();
        this.collections = new ArrayList<Collection>();
        this.followers = new HashSet<>();
        this.notificationStyle = null;
    }
    
    public User getUser()
    {
    	return actualUser;
    }
    
    public String getFirstName()
    {
    	return firstName;
    }
    
    public String getLastName()
    {
    	return lastName;
    }
    
    public boolean addCollection(String collectionName)
    {
    	checkCollections();
    	for(Collection collection : collections)
    	{
    		if(collection.getCollectionName().equals(collectionName)) return false;
    	}
    	collections.add(new Collection(collectionName));
    	return true;
    }
    
    public boolean addPhoto(String collectionName, String name, String blobKey)
    {
    	checkCollections();
    	for(Collection collection : collections)
    	{
    		if(collection.getCollectionName().equals(collectionName))
    		{
    			collection.addPhoto(name, blobKey);
    			return true;
    		}
    	}
    	return false;
    }
    
    public boolean containsCollection(String collectionName)
    {
    	checkCollections();
    	for(Collection collection : collections)
    	{
    		if(collection.getCollectionName().equals(collectionName))
    		{
    			return true;
    		}
    	}
    	return false;
    }
    
    public ArrayList<Collection> getCollections()
    {
    	checkCollections();
    	return collections;
    }
    
    private void checkCollections()
    {
    	if(collections == null) this.collections = new ArrayList<Collection>();
    }
    
    @Override
    public int compareTo(Profile other) {
        if (date.after(other.date)) {
            return 1;
        } else if (date.before(other.date)) {
            return -1;
        }
        return 0;
     }
	@Override
	public void addFollower(Follower f) {
		followers.add(f);
	}
	
	@Override
	public void removeFollower(Follower f) {
		followers.remove(f);
	}
	
	@Override
	public void notifyFollowers() {
		for (Follower follower : followers) {
			follower.update();
		}
	}
	
	@Override
	public void update() {
		if (notificationStyle != null)
			notificationStyle.alert();
	}
    
}
