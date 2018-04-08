package collectionconnection;

import java.util.Date;

public class CustomNotification extends Notification {

	@Override
	public boolean isWithinTimePeriod(Date from) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public String getContent(Date from, boolean getComments, boolean getCollections) {
		// TODO Auto-generated method stub
		return null;
	}
	

}
