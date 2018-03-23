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
<title>My Profile</title>
</head>
<body>
	<% 
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		List<Profile> profiles = ObjectifyService.ofy().load().type(Profile.class).list();
		Profile targetProfile = null;
		for(Profile profile : profiles)
		{
			if(profile.getUser().equals(user))
			{
				targetProfile = profile;
				break;
			}
		}
		
		if(targetProfile != null)
		{
			pageContext.setAttribute("firstName", targetProfile.getFirstName());
			pageContext.setAttribute("lastName", targetProfile.getLastName());
	%>		
	<h1> ${fn:escapeXml(firstName)} ${fn:escapeXml(lastName)} </h1>
	<a href="imageTest.jsp" role="button">Add Collection</a>	
	<br>
	<br>
	<a href="welcomePage.jsp" role="button">Back to Home</a>
	<% 
		}
	%>
</body>
</html>