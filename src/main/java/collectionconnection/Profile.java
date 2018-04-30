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
    private Notification notification;
    
    private Profile() {}
    public Profile(User user, String username) {
    	this.actualUser = user;
    	this.username = username;
        this.date = new Date();
        this.notificationLog = new TreeSet<>();
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
    
    public Set<Ref<Follower>> getFollowers() {
    	return followers;
    }
    
    public TreeSet<NotificationText> getNotificationLog() {
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
    
    public void changeNotificationSettings(boolean sendCollections, boolean sendPhotos, boolean sendComments) {
    	notification.set(sendCollections, sendPhotos, sendComments);
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
		//notifyFollowers(new FollowerNotificationText(username));
		followers.add(f);
	}
	
	@Override
	public void removeFollower(Ref<Follower> f) {
		followers.remove(f);
	}
	
	@Override
	public void notifyFollowers(NotificationText notification) {
		/*
		for (Ref<Follower> follower : followers) {
			follower.get().update(notification);
		}
		*/
		this.update(notification);
	}
	
	@Override
	public void update(NotificationText notification) {
		try {
			InternetAddress[] realTimeEmails = getFollowerEmails(true);
			Notification.alert(notification.getNotificationText(), realTimeEmails);
			notificationLog.add(notification);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
    
	public InternetAddress[] getFollowerEmails(boolean realTime) throws AddressException {
		ArrayList<InternetAddress> addresses = new ArrayList<>();
		//System.out.println(actualUser.getEmail());
		for (Ref<Follower> follower : followers) {
			Profile profile = (Profile)follower.get();
			NotificationType type = profile.notification.getNotificationType();
			if ((realTime && type == NotificationType.REALTIME) || (!realTime && type == NotificationType.DAILY)) {
				addresses.add(new InternetAddress(profile.actualUser.getEmail()));
			} 
		}
		System.out.println("Sending to: " + addresses.toString());
		InternetAddress[] add = new InternetAddress[addresses.size()];
		for(int i = 0; i < addresses.size(); i++)
		{
			add[i] = addresses.get(i);
		}
		return add;
	}
}
