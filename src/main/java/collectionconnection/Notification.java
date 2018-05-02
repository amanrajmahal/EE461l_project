package collectionconnection;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


public class Notification {
	private NotificationType notificationType;
	private boolean sendCollections;
	private boolean sendPhotos;
	private boolean sendFollowers;
	
	public Notification() {
		this.notificationType = NotificationType.REALTIME;
		this.sendCollections = false;
		this.sendPhotos = false;
		this.sendFollowers = false;
	}
	
	public Notification(NotificationType type, boolean sendCollections, boolean sendPhotos, boolean sendFollowers) {
		this.notificationType = type;
		this.sendCollections = sendCollections;
		this.sendPhotos = sendPhotos;
		this.sendFollowers = sendFollowers;
	}
	
	public NotificationType getNotificationType() {
		return notificationType;
	}
	
	public boolean includeCollections() {
		return sendCollections;
	}
	
	public boolean includePhotos() {
		return sendPhotos;
	}
	
	public boolean includeFollowers() {
		return sendFollowers;
	}
	
	public void set(boolean sendCollections, boolean sendPhotos, boolean sendFollowers) {
		this.sendCollections = sendCollections;
		this.sendPhotos = sendPhotos;
		this.sendFollowers = sendFollowers;
		System.out.println("Collections: " + this.sendCollections + "\nPhotos: " + this.sendPhotos + "\nFollowers: " + this.sendFollowers);
	}
	
	public void setNotificationType(NotificationType notificationType) {
		this.notificationType = notificationType;
	}
	
	// new method
	public static void alert(String username, String body, String email) {
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress("admin@collection-connection.appspotmail.com","Collection Connection Digest"));
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
			msg.setSubject("Notifications from Collection Connection");
			String html = "<div style=\"font-family:Georgia; font-size:13px\"><p>Hey " + username + ", <br><br>This is what you missed today.<br><br><br>" +
					body + "</p><br><br>" + "<a href=\"https://collection-connection.appspot.com\">Visit Collection Connection</a><br><br>" +
					"<b>Collection Connection Team</b></div>";
					
			msg.setContent(html, "text/html");
			Transport.send(msg);
		} catch (Exception e) {
			e.printStackTrace();
		}	 
	}
}
