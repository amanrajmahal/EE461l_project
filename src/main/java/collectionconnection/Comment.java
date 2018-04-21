package collectionconnection;

import java.util.Date;
import com.google.appengine.api.users.User;

public class Comment {
	private User user;
	private String comment;
	private Date date;
	
	private Comment() {}
	
	public Comment(User user, String comment) {
		this.user = user;
		this.comment = comment;
		this.date = new Date();
	}
	
	public User getUser() {
		return user;
	}
	
	public String getComment() {
		return comment;
	}
	
	public Date getDate() {
		return date;
	}
}
