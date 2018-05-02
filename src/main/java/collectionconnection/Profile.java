package collectionconnection;
import javax.mail.internet.AddressException;
import static com.googlecode.objectify.ObjectifyService.ofy;
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
    private ArrayList<Collection> collections = new ArrayList<>();
    private Notification notification;
    private ArrayList<NotificationText> notificationLog = new ArrayList<>();
    
    private Profile() {}
    public Profile(User user, String username) {
    	this.actualUser = user;
    	this.username = username;
        this.date = new Date();
        this.notificationLog = new ArrayList<>();
        this.collections = new ArrayList<>();
        this.followers = new HashSet<>();
        this.notification = new Notification();
    }
    
    public User getUser()
    {
    	return actualUser;
    }
    
    public String getUsername()
    {
    	return username;
    }
    
    public Notification getNotification() {
    	return notification;
    }
    
    public NotificationType getNotificationType() {
    	return this.notification.getNotificationType();
    }
    
    public Set<Ref<Follower>> getFollowers() {
    	return followers;
    }
    
    public ArrayList<NotificationText> getNotificationLog() {
    	return notificationLog;
    }
    
    public void changeNotificationType(String type) {
    	if (type.equals("none")) {
    		this.notification.setNotificationType(NotificationType.NONE); System.out.println("Set to none");
    	}
    	else if (type.equals("realtime")) {
    		this.notification.setNotificationType(NotificationType.REALTIME); System.out.println("Set to realtime");
    	}
    	else if (type.equals("daily")) {
    		this.notification.setNotificationType(NotificationType.DAILY); System.out.println("Set to realtime");
    	}
    }
    
    public void changeNotificationSettings(boolean sendCollections, boolean sendPhotos, boolean sendFollowers) {
    	notification.set(sendCollections, sendPhotos, sendFollowers);
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
			notifyFollowers(new PhotoNotificationText(username, collectionName));
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
		Profile other = (Profile)f.get();
		notifyFollowers(new FollowerNotificationText(other.username));
		followers.add(f);
	}
	
	@Override
	public void removeFollower(Ref<Follower> f) {
		followers.remove(f);
	}
	
	@Override
	public void notifyFollowers(NotificationText notification) {
		if (notification instanceof FollowerNotificationText) {
			if (this.notification.getNotificationType() == NotificationType.DAILY) {
				this.notificationLog.add(notification);
				ofy().save().entity(this).now();
			}
			else {
				Notification.alert(notification.getNotificationText(), actualUser.getEmail());
			}
		}
		
		else {
			for (Ref<Follower> follower : followers) {
				Profile profile = (Profile)follower.get();
				profile.update(notification);
			}
		}
	}
	
	@Override
	public void update(NotificationText notification) {
		if (notification instanceof CollectionNotificationText && this.notification.includeCollections()
				|| notification instanceof PhotoNotificationText && this.notification.includePhotos()) {
			if (this.notification.getNotificationType() == NotificationType.DAILY) {
				 this.notificationLog.add(notification);
				 ofy().save().entity(this).now();
			}
			else Notification.alert(notification.getNotificationText(), actualUser.getEmail());
		}
	}
}
