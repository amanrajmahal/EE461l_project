package collectionconnection;
import java.util.Date;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

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
    	notifyFollowers(new CollectionNotificationText(firstName + " " + lastName, collectionName));
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
    			notifyFollowers(new PhotoNotificationText(firstName + " " + lastName, name, collectionName));
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
	public void notifyFollowers(NotificationText notification) {
		for (Follower follower : followers) {
			follower.update(notification);
		}
	}
	
	@Override
	public void update(NotificationText notification) {
		try {
			InternetAddress[] emails = getFollowerEmails();

			if (notificationStyle instanceof RealTimeNotification)
				notificationStyle.alert(notification, emails);
			else if (notificationStyle instanceof CustomNotification)
				notificationStyle.alert(null, emails);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public InternetAddress[] getFollowerEmails() throws AddressException {
		InternetAddress[] emails = new InternetAddress[followers.size()];
		int i = 0;
		for (Follower follower : followers) {
			Profile profile = (Profile)follower;
			emails[i] = new InternetAddress(profile.actualUser.getEmail());
			i++;
		}
		return emails;
	}
    
}
