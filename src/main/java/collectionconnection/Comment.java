package collectionconnection;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.HOUR, -5);
		this.user = user;
		this.comment = comment;
		this.date = cal.getTime();
		this.commentId = commentId;
	}
	
	public User getUser() {
		return user;
	}
	
	public String getComment() {
		return comment;
	}
	
	public String getDate() {
		DateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
		return dateFormat.format(date);
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
