package collectionconnection;
import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.*;
import java.util.HashSet;
import java.util.Observable;
import java.util.Observer;
import java.util.Set;

@Entity
public class Profile extends Observable implements Comparable<Profile>, Observer {
    @Parent Key<ProfileKey> user;
    @Id Long id;
    @Index User actualUser;
    @Index String firstName;
    @Index String lastName;
    @Index Date date;
    
    Set<Profile> subscriptionList;
	Notification notificationStyle;
    
    private ArrayList<Collection> collections;
    
    private Profile() {}
    public Profile(User user, String firstName, String lastName) { 
    	this.user = Key.create(ProfileKey.class, user.getNickname());
    	this.actualUser = user;
    	this.firstName = firstName;
    	this.lastName = lastName;
        this.date = new Date();
        this.collections = new ArrayList<Collection>();
        subscriptionList = new HashSet<>();
		this.notificationStyle = null;
        //collections.add(new Collection("TestCollection"));
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
    
    public void addToSubscriberList(Profile profile) {
		subscriptionList.add(profile);
		profile.addObserver(o);
	}

	public void removeFromSubscriberList(Profile profile) {
		subscriptionList.remove(profile);
	}

	public void setNotificationStyle(Notification notificationStyle) {
		this.notificationStyle = notificationStyle;
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
	public void update(Observable o, Object arg) {
		if (this.notificationStyle.getClass() == RealTimeNotification.class) {
			notificationStyle.alert();
		}
	}
}