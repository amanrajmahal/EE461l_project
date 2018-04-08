package collectionconnection;

import java.util.Date;

public class RealTimeNotification extends Notification {

	@Override
	public boolean isWithinTimePeriod(Date from) {
		return false;
	
	}
	
	@Override
	public String getContent(Date from, boolean getComments, boolean getCollections) {
		// TODO Auto-generated method stub
		return null;
	}
	

}
