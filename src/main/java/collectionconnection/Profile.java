package collectionconnection;
import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class Profile implements Comparable<Photo> {
    @Parent Key<ProfileKey> user;
    @Id Long id;
    @Index User actualUser;
    @Index String firstName;
    @Index String lastName;
    @Index Date date;
    
    private Profile() {}
    public Profile(User user, String firstName, String lastName) { 
    	this.user = Key.create(ProfileKey.class, user.getNickname());
    	this.actualUser = user;
    	this.firstName = firstName;
    	this.lastName = lastName;
        this.date = new Date();
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
