package collectionconnection;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class CollectionKey {
    @Id long id;
    String name;

    public CollectionKey(String name) {
        this.name = name;
    }
}