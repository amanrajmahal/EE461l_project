package collectionconnection;

@SuppressWarnings("unused")
public class Photo {
	private String name;
	private String blobKey;
	
	private Photo() {}
	
	public Photo(String name, String blobKey)
	{
		this.name = name;
		this.blobKey = blobKey;
	}
	
	public String getName()
	{
		return name;
	}
	
	public String getBlobKey()
	{
		return blobKey;
	}
}