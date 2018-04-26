package collectionconnection;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class SeleniumTest {
	private static WebDriver driver;
	
	
	@BeforeClass
	public static void setUp() {
		driver = new FirefoxDriver();
		driver.get("http://localhost:8080");
		WebElement button = driver.findElement(By.linkText("Sign In"));
		button.click();
		button = driver.findElement(By.id("btn-login"));		
		button.click();
		WebElement text = driver.findElement(By.name("username"));
		text.sendKeys("bob");
		text.submit();
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void testSelenium() {
		// test adding collection
		WebDriverWait wait = new WebDriverWait(driver, 10);
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("My Profile")));
		driver.findElement(By.linkText("My Profile")).click();
		WebElement textField = driver.findElement(By.name("collection"));
		textField.sendKeys("testCollection");
		textField.submit();
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("My Profile")));
		driver.findElement(By.linkText("My Profile")).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("testCollection")));
		WebElement element = driver.findElement(By.linkText("testCollection"));
		element.click();
		assertEquals(driver.getCurrentUrl(), "http://localhost:8080/collectionPage.jsp?username=bob&collection=testCollection");
		
		// test comment
		wait.until(ExpectedConditions.presenceOfElementLocated(By.name("comment")));
		WebElement txtArea = driver.findElement(By.name("comment"));
		txtArea.sendKeys("Test comment");
		txtArea.submit();
		driver.navigate().refresh();
		wait.until(ExpectedConditions.presenceOfElementLocated(By.id("commentTest")));
		List<WebElement> comments = driver.findElements(By.id("commentTest"));
		String commentContent = comments.get(0).getText();
		assertEquals(commentContent, "bob: Test comment");
		
		// test comment from different user
		driver.navigate().to("http://localhost:8080");
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("Sign Out")));
		driver.findElement(By.linkText("Sign Out")).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("Sign In")));
		driver.findElement(By.linkText("Sign In")).click();
		wait.until(ExpectedConditions.presenceOfElementLocated(By.id("email")));
		WebElement email = driver.findElement(By.id("email"));
		email.clear();
		email.sendKeys("test@test.com");
		email.submit();
		wait.until(ExpectedConditions.presenceOfElementLocated(By.name("username")));
		WebElement text = driver.findElement(By.name("username"));
		text.sendKeys("jake");
		text.submit();
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("bob")));
		driver.findElement(By.linkText("bob")).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("testCollection")));
		driver.findElement(By.linkText("testCollection")).click();
		wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("commentTest")));
		List<WebElement> commentsAgain = driver.findElements(By.id("commentTest"));
		assertTrue(commentsAgain.size() == 1);
		assertEquals(commentsAgain.get(0).getText(), "bob: Test comment");
		
		// test follower
		driver.navigate().back();
		wait.until(ExpectedConditions.elementToBeClickable(By.id("followerTest")));
		WebElement followButton = driver.findElement(By.id("followerTest"));
		driver.findElement(By.id("followerTest")).click();
		driver.navigate().refresh();
		wait.until(ExpectedConditions.elementToBeClickable(By.id("followerTest")));
		followButton = driver.findElement(By.id("followerTest"));
		wait.until(ExpectedConditions.attributeToBe(followButton, "value", "Unfollow"));
		assertEquals(followButton.getAttribute("value"), "Unfollow");
		driver.findElement(By.id("followerTest")).click();
		driver.navigate().refresh();
		wait.until(ExpectedConditions.elementToBeClickable(By.id("followerTest")));
		followButton = driver.findElement(By.id("followerTest")); 
		wait.until(ExpectedConditions.attributeToBe(followButton, "value", "Follow"));
		assertEquals(followButton.getAttribute("value"), "Follow");
	}
	
	
	@AfterClass
	public static void cleanUp() {
		driver.close();
	}

}
