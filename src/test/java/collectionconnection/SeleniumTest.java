package collectionconnection;

import static org.junit.Assert.*;

import org.junit.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

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
	public void test() {
		
		
		
	}
	
	@AfterClass
	public static void cleanUp() {
		driver.close();
	}

}
