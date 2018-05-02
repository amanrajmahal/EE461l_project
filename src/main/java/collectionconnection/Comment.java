package collectionconnection;

import java.util.Date;
import com.google.appengine.api.users.User;

@SuppressWarnings("unused")
public class Comment implements Comparable<Comment>{
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

	@Override
	public int compareTo(Comment o) {
		if (date.after(o.date)) {
            return -1;
        } else if (date.before(o.date)) {
            return 1;
        }
        return 0;
	}

}
