package collectionconnection;

import com.googlecode.objectify.annotation.Subclass;

@Subclass
public class CommentNotificationText extends NotificationText {
	private String user;
	private String comment;
	private String collectionName;
	
	@SuppressWarnings("unused")
	private CommentNotificationText() {}
	
	public CommentNotificationText(String user, String comment, String collectionName) {
		super();
		this.user = user;
		this.comment = comment;
		this.collectionName = collectionName;
	}
	
	@Override
	public String getNotificationText() {
		return String.format( "%s commented \"%s\" on your collection \"%s\"", user, comment, collectionName);
	}

}
