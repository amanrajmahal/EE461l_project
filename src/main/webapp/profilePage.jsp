<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<script>
$(document).ready(function(){
	$("body").css("background-color","blue").fadeIn(3000);
	$("#addCollection").css("color","blue");
	$("#homePage").css("color","green")
	$("#name").css("color","cyan")
    $("#addCollection").click(function(){
    	//href = "imageTest.jsp"
    	window.location = "imageTest.jsp";
    });
    $("#homePage").click(function(){
    	window.location = "welcomePage.jsp";
    });
});


</script>
<title>My Profile</title>
</head>
<body>
	<% 
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		Profile targetProfile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();		
		if(targetProfile != null)
		{
			pageContext.setAttribute("username", targetProfile.getUsername());
	%>		
	<h1 id = "name"> ${fn:escapeXml(username)} </h1>
	<!--  a href="imageTest.jsp" role="button">Add Collection</a>	-->
	<button id="addCollection" > Add Collection</button>
	<br>
	<br>	
	<button id ="homePage">Back to Homepage</button>
	<% 
		}
	%>
</body>
</html>