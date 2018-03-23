package collectionconnection;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class ProfileKey {
    @Id long id;
    String name;

    public ProfileKey(String name) {
        this.name = name;
    }
}
