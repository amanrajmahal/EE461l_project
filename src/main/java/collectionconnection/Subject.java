package collectionconnection;

import com.googlecode.objectify.Ref;

public interface Subject {
	public void addFollower(Ref<Follower> f);
	public void removeFollower(Ref<Follower> f);
	public void notifyFollowers(NotificationText notification);

}
