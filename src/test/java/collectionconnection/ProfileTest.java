package collectionconnection;

import static org.junit.Assert.*;
import java.util.Date;

import org.junit.Test;

public class ProfileTest {
	@Test
	public void basicPhotoTest()
	{
		Photo photo = new Photo("Nick", "Key");
		assertTrue(photo.getName().equals("Nick"));
		assertTrue(photo.getBlobKey().equals("Key"));
	}
	
	@SuppressWarnings("unused")
	@Test
	public void basicCollectionTest()
	{
		Collection collection = new Collection("Test");
		assertTrue(collection.getComments() !=  null);
		assertTrue(collection.getComments().size() ==  0);
		assertTrue(collection.getPhotos() !=  null);
		assertTrue(collection.getPhotos().size() ==  0);
		collection.addPhoto("Nick", "Key");
		assertTrue(collection.getPhotos() !=  null);
		assertTrue(collection.getPhotos().size() ==  1);
		assertTrue(collection.getPhotos().get(0).getName().equals("Nick"));
		assertTrue(collection.getPhotos().get(0).getBlobKey().equals("Key"));
		Date testDate = new Date();
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		collection.addComment("comment", null);
		assertTrue(collection.getComments() !=  null);
		assertTrue(collection.getComments().size() ==  1);
		assertTrue(collection.getComments().get(0).getUser() == null);
		assertTrue(collection.getComments().get(0).getComment() == "comment");
		//assertTrue(collection.getComments().get(0).getDate().after(testDate));
	}
	
	@Test
	public void basicProfileTest()
	{
		Profile profile = new Profile(null, "Nick", true);
		assertTrue(profile.getCollections() != null);
		assertTrue(profile.getCollections().size() == 0);
		assertTrue(profile.getUser() == null);
		assertTrue(profile.getUsername()!= null);
		assertTrue(profile.getUsername().equals("Nick"));
		profile.addCollection("Collection");
		assertTrue(profile.getCollections().size() == 1);
		assertTrue(profile.getCollections().get(0).getCollectionName().equals("Collection"));
		profile.addPhoto("Collection", "Nick", "Key");
		assertTrue(profile.getCollections().get(0).getPhotos().get(0).getName().equals("Nick"));
		assertTrue(profile.getCollections().get(0).getPhotos().get(0).getBlobKey().equals("Key"));
	}
	
	@Test
	public void collectionTest() {
		Profile p1 = new Profile(null, "John", true);
		p1.addCollection("Collection1");
		assertTrue(p1.getCollections().get(0).getCollectionName().equals("Collection1"));
	}
	
	@Test
	public void photoTest() {
		Profile p1 = new Profile(null, "John", true);
		p1.addCollection("Collection1");
		p1.addPhoto("Collection1", "Photo1", "blob");
		assertTrue(p1.getCollections().get(0).getPhotos().get(0).getName().equals("Photo1"));
	}
	
	@Test
	public void commentTest() {
		Profile p1 = new Profile(null, "John", true);
		p1.addCollection("Collection1");
		p1.addPhoto("Collection1", "Photo1", "blob");
		p1.getCollections().get(0).addComment("Great", null);
		assertTrue(p1.getCollections().get(0).getComments().get(0).getComment().equals("Great"));
	}
}