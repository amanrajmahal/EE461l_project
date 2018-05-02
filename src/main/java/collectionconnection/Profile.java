package collectionconnection;
import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.Ref;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Load;
import com.googlecode.objectify.annotation.Parent;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@Entity
public class Profile implements Comparable<Profile>, Follower, Subject {
	@Parent Key<Profile> parent;
    @Id Long id;
    @Index User actualUser;
    @Index String username;
    
    @Load private Set<Ref<Follower>> followers = new HashSet<>();
    
    private Date date;
    private ArrayList<Collection> collections = new ArrayList<>();
    private Notification notification;
    private ArrayList<NotificationText> notificationLog = new ArrayList<>();
    private Photo profilePhoto = new Photo("profilePhoto", null);
    
    @SuppressWarnings("unused")
    private Profile() {}
    
    public Profile(User user, String username) {
    	this.actualUser = user;
    	this.username = username;
        this.date = new Date();
        this.notificationLog = new ArrayList<>();
        this.collections = new ArrayList<>();
        this.followers = new HashSet<>();
        this.notification = new Notification();
        this.profilePhoto = new Photo("profilePhoto", null);
        this.parent = Key.create(Profile.class, "profiles");
    }
    
    public User getUser()
    {
    	return actualUser;
    }
    
    public void setProfilePhoto(String blobKey)
    {
    	profilePhoto = new Photo("profilePhoto", blobKey);
    }
    
    public Photo getProfilePhoto()
    {
    	return profilePhoto;
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
			else if (this.notification.getNotificationType() == NotificationType.REALTIME) {
				alert(notification);
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
			else if (this.notification.getNotificationType() == NotificationType.REALTIME) {
				alert(notification);
			}
		}
	}
	
	public void alert(NotificationText notification) {
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);
		Message msg = new MimeMessage(session);
		String body = "";
		if (this.notification.getNotificationType() == NotificationType.DAILY) {
			body = getLogString();
		}
		else if (this.notification.getNotificationType() == NotificationType.REALTIME) {
			body = notification.getNotificationText();
		}
		if (body.length() != 0) {
			try {
				msg.setFrom(new InternetAddress("admin@collection-connection.appspotmail.com","Collection Connection Digest"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(actualUser.getEmail()));
				msg.setSubject("Notifications from Collection Connection");
				String html = "<div style=\"font-family:Georgia; font-size:12px\"><p>Hey " + username + ", <br><br>Here's what you missed.<br><br><br>" +
						body + "</p><br><br>" + "<a href=\"https://collection-connection.appspot.com\">Visit Collection Connection</a><br><br>" +
						"<b>Collection Connection Team</b></div>";
					
				msg.setContent(html, "text/html");
				Transport.send(msg);
			} catch (Exception e) {
				e.printStackTrace();
			}	 
		}
	}
	
	public String getLogString() {
		StringBuilder str = new StringBuilder();
		DateFormat dateFormat = new SimpleDateFormat("hh:mm a");
		for (NotificationText text : notificationLog) {
			String date = dateFormat.format(text.getDate());
			str.append(date).append(":  ").append(text.getNotificationText()).append("\n");
		}
		notificationLog.clear();
		return str.toString();
	}
}
