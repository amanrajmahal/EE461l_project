package collectionconnection;
import java.util.Date;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Ref;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;

import java.util.*;

@Entity
public class Profile implements Comparable<Profile>, Follower, Subject {
    @Id Long id;
    @Index User actualUser;
    
    @Load private Set<Ref<Follower>> followers = new HashSet<>();
    
    private String firstName;
    private String lastName;
    private Date date;
    private HashSet<NotificationText> notificationLog = new HashSet<>();
    private ArrayList<Collection> collections = new ArrayList<>();
    private Notification notificationStyle;
    
    private Profile() {}
    public Profile(User user, String firstName, String lastName) {
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
    
    public void changeNotificationStyle(Notification notification) {
    	this.notificationStyle = notification;
    }
    
    public boolean addCollection(String collectionName)
    {
    	Collection collection = findCollection(collectionName);
    	if (collection == null) {
    		collections.add(new Collection(collectionName));
    		notifyFollowers(new CollectionNotificationText(firstName + " " + lastName, collectionName));
    		return true;
    	}
    	return false;
    }
    
    public boolean addPhoto(String collectionName, String name, String blobKey)
    {
    	Collection collection = findCollection(collectionName);
    	if (collection != null) {
    		collection.addPhoto(name, blobKey);
			notifyFollowers(new PhotoNotificationText(firstName + " " + lastName, name, collectionName));
			return true;
    	}
    	return false;
    }
    
	public Collection findCollection(String collectionName)
    {
    	//checkCollections();
    	for(Collection collection : collections)
    	{
    		if(collection.getCollectionName().equals(collectionName))
    		{
    			return collection;
    		}
    	}
    	return null;
    }
    
    public ArrayList<Collection> getCollections()
    {
    	//checkCollections();
    	return collections;
    }
    
    /*private void checkCollections()
    {
    	if(collections == null) {
    		this.collections = new ArrayList<Collection>();
    	}
    		
    }*/
    
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
	public void addFollower(Ref<Follower> f) {
		//checkFollowers();
		followers.add(f);
	}
	
	@Override
	public void removeFollower(Ref<Follower> f) {
		//checkFollowers();
		followers.remove(f);
	}
	
	@Override
	public void notifyFollowers(NotificationText notification) {
		//checkFollowers();
		for (Ref<Follower> follower : followers) {
			follower.get().update(notification);
		}
	}
	
	@Override
	public void update(NotificationText notification) {
		// checkFollowers();
		try {
			if (notificationStyle instanceof RealTimeNotification)
				notificationStyle.alert(notification, getFollowerEmails());
			else notificationLog.add(notification);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
    
	public InternetAddress[] getFollowerEmails() throws AddressException {
		//checkFollowers();
		InternetAddress[] emails = new InternetAddress[followers.size()];
		int i = 0;
		for (Ref<Follower> follower : followers) {
			Profile profile = (Profile)follower.get();
			emails[i] = new InternetAddress(profile.actualUser.getEmail());
			i++;
		}
		return emails;
	}
	
    /*private void checkFollowers()
    {
    	if(followers == null) {
    		this.followers = new HashSet<>();
    	}
    }*/
    
}
