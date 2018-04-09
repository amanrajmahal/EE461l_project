package collectionconnection;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public abstract class Notification {
	private NotificationOptions options;
	
	public Notification() {
		options = new NotificationOptions();
	}

	class NotificationOptions {
		private boolean sendComments;
		private boolean sendCollections;
		private int numHours;

		NotificationOptions() {
			sendComments = true;
			sendCollections = true;
			numHours = 1;
		}

		public void setComments(boolean sendComments) {
			this.sendComments = sendComments;
		}

		public void setCollections(boolean sendCollections) {
			this.sendCollections = sendCollections;
		}

		public void setNumHoursBack(int hours) {
			numHours = hours;
		}
		
		public boolean getComments() {
			return sendComments;
		}
		
		public boolean getCollections() {
			return sendCollections;
		}
		
		public int getNumHours() {
			return numHours;
		}
	}
	
	public NotificationOptions getOptions() {
		return options;
	}

	public void alert(NotificationText text, InternetAddress[] emails) {
		Properties properties = new Properties();
		Session session = Session.getDefaultInstance(properties, null);
		String content = getContent(text);
		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress("admin@collectionconnection.appspotmail.com","CollectionConnection Digest"));
			msg.addRecipients(Message.RecipientType.BCC, emails);
			msg.setSubject("Digest");
			msg.setText(content);
			Transport.send(msg);	
		} catch (Exception e) {
			e.printStackTrace();
		}	 
	}

	public abstract String getContent(NotificationText text);
}
