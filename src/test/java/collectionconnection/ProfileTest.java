package collectionconnection;

import static org.junit.Assert.*;

import org.junit.Test;

public class ProfileTest {
	@Test
	public void collectionTest() {
		Profile p1 = new Profile(null, "John");
		p1.addCollection("Collection1");
		assertTrue(p1.getCollections().get(0).getCollectionName().equals("Collection1"));
	}
	
	@Test
	public void photoTest() {
		Profile p1 = new Profile(null, "John");
		p1.addCollection("Collection1");
		p1.addPhoto("Collection1", "Photo1", "blob");
		assertTrue(p1.getCollections().get(0).getPhotos().get(0).getName().equals("Photo1"));
	}
	
	@Test
	public void commentTest() {
		Profile p1 = new Profile(null, "John");
		p1.addCollection("Collection1");
		p1.addPhoto("Collection1", "Photo1", "blob");
		p1.getCollections().get(0).addComment("Great", null);
		assertTrue(p1.getCollections().get(0).getComments().get(0).getComment().equals("Great"));
	}
}