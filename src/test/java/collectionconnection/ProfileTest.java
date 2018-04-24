package collectionconnection;

import static org.junit.Assert.*;
import collectionconnection.Profile;

import org.junit.Test;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.Ref;

public class ProfileTest {

	@Test
	public void test() {
		ObjectifyService.register(Profile.class);
		Profile p1 = new Profile(null, "John");
		Profile p2 = new Profile(null, "Nick");
		p2.id =(long)2;
		Follower f = p2;
		//Ref.create(f);
		//p1.addFollower(Ref.create(p2));
	}

}
