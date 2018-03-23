<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="java.util.*" %>
<%@ page import="collectionconnection.Profile"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Collection Connection Home</title>
</head>
<body>
	<h1>Collection Connection</h1>
	<% 
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user == null) {
	%>		
		<a class="accountbutton btn btn-secondary btn-sm" href="<%=userService.createLoginURL(request.getRequestURI()) %>" role="button">Sign In</a>
		<br>
		<br>

	<% 
		} else {
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
		<p> Hello ${fn:escapeXml(firstName)}! </p>
		<a class="accountbutton btn btn-secondary btn-sm" href="<%=userService.createLogoutURL(request.getRequestURI()) %>" role="button">Sign Out</a>
		<br>
		<br>
		<a href="profilePage.jsp">My Profile</a>
	<%
			}
			else
			{
	%>
		<p> Hello new user! Please input your information below. </p>
		<form action="/profile" method="post">
			<div><textarea name = "firstName" rows="1" cols="60"></textarea></div>
			<div><textarea name = "lastName"  rows="1" cols="60"></textarea></div>
			<input type="submit" value="Submit">
		</form>
	<%
			}
		}
	%>
</body>
</html>