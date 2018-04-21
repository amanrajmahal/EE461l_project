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
    @Index String username;
    
    @Load private Set<Ref<Follower>> followers = new HashSet<>();
    
    private Date date;
    private TreeSet<NotificationText> notificationLog = new TreeSet<>();
    private ArrayList<Collection> collections = new ArrayList<>();
    private Notification notificationStyle;
    
    private Profile() {}
    public Profile(User user, String username) {
    	this.actualUser = user;
    	this.username = username;
        this.date = new Date();
        this.notificationLog = new TreeSet<>();
        this.collections = new ArrayList<Collection>();
        this.notificationLog = new TreeSet<>();
        this.followers = new HashSet<>();
        this.notificationStyle = null;
    }
    
    public User getUser()
    {
    	return actualUser;
    }
    
    public String getUsername()
    {
    	return username;
    }
    
    public TreeSet<NotificationText> getNotificationLog() {
    	return notificationLog;
    }
    
    public void changeNotificationStyle(Notification notification) {
    		this.notificationStyle = notification;
    }
    
    public boolean addCollection(String collectionName)
    {
    	Collection collection = findCollection(collectionName);
    	if (collection == null) {
    		collections.add(new Collection(collectionName));
    		notifyFollowers(new CollectionNotificationText(username, collectionName));
    		return true;
    	}
    	return false;
    }
    
    public boolean addPhoto(String collectionName, String name, String blobKey)
    {
    	Collection collection = findCollection(collectionName);
    	if (collection != null) {
    		collection.addPhoto(name, blobKey);
			notifyFollowers(new PhotoNotificationText(username, name, collectionName));
			return true;
    	}
    	return false;
    }
    
	public Collection findCollection(String collectionName)
    {
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
    	return collections;
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
	public void addFollower(Ref<Follower> f) {
		followers.add(f);
	}
	
	@Override
	public void removeFollower(Ref<Follower> f) {
		followers.remove(f);
	}
	
	@Override
	public void notifyFollowers(NotificationText notification) {
		for (Ref<Follower> follower : followers) {
			follower.get().update(notification);
		}
	}
	
	@Override
	public void update(NotificationText notification) {
		try {
			InternetAddress[] realTimeEmails = getFollowerEmails(true);
			Notification.alert(notification, realTimeEmails);
			notificationLog.add(notification);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    
	public InternetAddress[] getFollowerEmails(Boolean realTime) throws AddressException {
		ArrayList<InternetAddress> addresses = new ArrayList<>();
		//InternetAddress[] emails = new InternetAddress[followers.size()];
		//int i = 0;
		for (Ref<Follower> follower : followers) {
			Profile profile = (Profile)follower.get();
			if (realTime && profile.notificationStyle instanceof RealTimeNotification) {
				addresses.add(new InternetAddress(profile.actualUser.getEmail()));
				//emails[i] = new InternetAddress(profile.actualUser.getEmail());
				//i++;
			}
		}
		return (InternetAddress[])addresses.toArray();
	}
}
