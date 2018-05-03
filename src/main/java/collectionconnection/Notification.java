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
}
