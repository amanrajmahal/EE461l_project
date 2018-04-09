package collectionconnection;

public interface Subject {
	public void addFollower(Follower f);
	public void removeFollower(Follower f);
	public void notifyFollowers();

}
