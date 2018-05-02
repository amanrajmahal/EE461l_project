package collectionconnection;

import java.util.Properties;
import java.util.TreeSet;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


public class Notification {
	private NotificationType notificationType;
	private boolean sendComments;
	private boolean sendCollections;
	private boolean sendPhotos;
	private boolean sendFollowers;
	
	public Notification() {
		this.notificationType = NotificationType.REALTIME;
		this.sendComments = false;
		this.sendCollections = false;
		this.sendPhotos = false;
		this.sendFollowers = false;
	}
	
	public Notification(NotificationType type, boolean sendComments, boolean sendCollections, boolean sendPhotos, boolean sendFollowers) {
		this.notificationType = type;
		this.sendComments = sendComments;
		this.sendCollections = sendCollections;
		this.sendPhotos = sendPhotos;
		this.sendFollowers = sendFollowers;
	}
	
	public NotificationType getNotificationType() {
		return notificationType;
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
	
	public void set(boolean sendCollections, boolean sendPhotos, boolean sendComments) {
		this.sendCollections = sendCollections;
		this.sendPhotos = sendPhotos;
		this.sendComments = sendComments;
		System.out.println("Collections: " + this.sendCollections + "\nPhotos: " + this.sendPhotos + "\nComments: " + this.sendComments);
	}
	
	public void setNotificationType(NotificationType notificationType) {
		this.notificationType = notificationType;
	}
	
	// new method
	public static void alert(String text, String email) {
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress("admin@collection-connection.appspotmail.com","Collection Connection Digest"));
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
			msg.setSubject("Notifications from Collection Connection");
			msg.setText(text);
			Transport.send(msg);
		} catch (Exception e) {
			e.printStackTrace();
		}	 
	}
}
