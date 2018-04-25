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
	public void testCollection() throws InterruptedException {
		System.out.println("In testCollection");
		// test adding collection
		driver.findElement(By.linkText("My Profile")).click();
		WebElement textField = driver.findElement(By.name("collection"));
		textField.sendKeys("testCollection");
		textField.submit();
		WebDriverWait wait = new WebDriverWait(driver, 10);
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("Back to My Profile")));
		driver.findElement(By.linkText("Back to My Profile")).click();
		wait.until(ExpectedConditions.elementToBeClickable(By.linkText("testCollection")));
		WebElement element = driver.findElement(By.linkText("testCollection"));
		element.click();
		
		// test comment
		WebElement txtArea = driver.findElement(By.id("txtArea"));
		txtArea.sendKeys("Test comment");
		txtArea.submit();
		wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("commentTest")));
		List<WebElement> comments = driver.findElements(By.className("commentTest"));
		System.out.println(comments.size());
		String commentContent = comments.get(0).getText();
		assertEquals(commentContent, "bob: Test comment");
		
		// test Follower
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
		wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("commentTest")));
		List<WebElement> commentsAgain = driver.findElements(By.className("commentTest"));
		assertTrue(commentsAgain.size() == 1);
		assertEquals(commentsAgain.get(0).getText(), "bob: Test comment");
		
	}
	
	
	@AfterClass
	public static void cleanUp() {
		driver.close();
	}

}
