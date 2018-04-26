package collectionconnection;

import java.util.Date;
import com.google.appengine.api.users.User;

public class Comment {
	private User user;
	private String comment;
	private Date date;
	private int commentId;
	
	private Comment() {}
	
	public Comment(User user, String comment, int commentId) {
		this.user = user;
		this.comment = comment;
		this.date = new Date();
		this.commentId = commentId;
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

	public int getCommentId() {
		return commentId;
	}

}
