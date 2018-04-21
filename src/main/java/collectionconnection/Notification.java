package collectionconnection;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public abstract class Notification {
	private boolean sendComments;
	private boolean sendCollections;
	private boolean sendPhotos;
	
	public Notification() {
		this.sendComments = false;
		this.sendCollections = false;
		this.sendPhotos = false;
	}
	
	public boolean includeComments() {
		return sendComments;
	}
	
	public boolean includeCollections() {
		return sendCollections;
	}
	
	public boolean includePhotos() {
		return sendPhotos;
	}
	
	public void setComments(boolean sendComments) {
		this.sendComments = sendComments;
	}
	
	public void setCollections(boolean sendCollections) {
		this.sendCollections = sendCollections;
	}
	
	public void setPhotos(boolean sendPhotos) {
		this.sendPhotos = sendPhotos;
	}

	public static void alert(NotificationText text, InternetAddress[] emails) {	
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);
		String content = text.getNotificationText();
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress("admin@collectionconnection.appspotmail.com","CollectionConnection Digest"));
			msg.addRecipients(Message.RecipientType.BCC, emails);
			msg.setSubject("Notifications from CollectionConnection");
			msg.setText(content);
			Transport.send(msg);	
		} catch (Exception e) {
			e.printStackTrace();
		}	 
	}

	public abstract String getContent(NotificationText text);
}
