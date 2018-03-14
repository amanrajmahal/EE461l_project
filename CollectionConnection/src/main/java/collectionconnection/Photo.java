package collectionconnection;
import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class Photo implements Comparable<Photo> {
    @Parent Key<CollectionKey> user;
    @Id Long id;
    @Index String profileName;
    @Index String collectionName;
    @Index String blobKey;
    @Index Date date;
    
    private Photo() {}
    public Photo(User user, String profileName, String collectionName, String blobKey) {
    	//delete this stuff once we have a sign in set up
    	if(user == null)
    	{
    		this.user = Key.create(CollectionKey.class, profileName);
    	}
    	else
    	{
    		this.user = Key.create(CollectionKey.class, user.getNickname());
    	}
    	this.profileName = profileName;
    	this.collectionName = collectionName;
    	this.blobKey = blobKey;
        this.date = new Date();
    }
    
    public String getProfileName() {
        return profileName;
    }
    
    public String getCollectionName() {
        return collectionName;
    }
    
    public String getBlobKey() {
        return blobKey;
    }

    @Override
    public int compareTo(Photo other) {
        if (date.after(other.date)) {
            return 1;
        } else if (date.before(other.date)) {
            return -1;
        }
        return 0;
     }
}