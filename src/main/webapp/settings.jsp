<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Notification"%>
<%@ page import="collectionconnection.NotificationType"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link type="text/css" rel="stylesheet" href="/stylesheets/style.css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<title>Settings</title>
</head>
<body class="body-margins">
<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		String username = profile.getUsername();
		Notification notificationSettings = profile.getNotification();
		pageContext.setAttribute("username", username);
		
%>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<a class="navbar-brand navbar-header" href="profilePage.jsp?username=<%=profile.getUsername()%>">Collection Connection</a>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="profilePage.jsp?username=<%=profile.getUsername()%>"><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
				<li><a href="settings.jsp"><span class="glyphicon glyphicon-cog"></span> Settings</a></li>
				<li><a href="browse.jsp"><span class="glyphicon glyphicon-search"></span> Browse</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="glyphicon glyphicon-log-out"></span>
					Sign Out</a></li>
			</ul>
			
			<form class="navbar-form navbar-left" action="/collection" method="post">
				<div class="form-group">
					<input type="text" name="collection" class="form-control" placeholder="Collection Name">
					<input type="hidden" name="username" value="${fn:escapeXml(username)}">
				</div>
				<input type="submit" class="btn btn-default" value="Add Collection">
			</form>
		</div>
	</nav>


<h2 class="header">Notification Settings</h2>
<br><br>
<br><br>
<h3>Notify me when...</h3>
<form id="settings" action="/settings" method="post">
	<label>
    <input type="radio" name="type" value="none"
    <%
    	if(notificationSettings.getNotificationType() == NotificationType.NONE)
    	{
    %>
    		checked
    <%
    	}
    %>
    /> Turn off notifications
	</label>
	<label>
    <input type="radio" name="type" value="realtime"
    <%
    	if(notificationSettings.getNotificationType() == NotificationType.REALTIME)
    	{
    %>
    		checked
    <%
    	}
    %>
    /> Send real-time notifications
	</label>
	<label>
    <input type="radio" name="type" value="daily"
    <%
    	if(notificationSettings.getNotificationType() == NotificationType.DAILY)
    	{
    %>
    		checked
    <%
    	}
    %>
    /> Send daily notifications
	</label>
	<br>
	<input type="checkbox" name="getCollections" value="collections"
	<%
    	if(notificationSettings.includeCollections())
    	{
    %>
    		checked
    <%
    	}
    %>
	> someone I follow adds a new collection <br>
	<input type="checkbox" name="getPhotos" value="photos"
	<%
    	if(notificationSettings.includePhotos())
    	{
    %>
    		checked
    <%
    	}
    %>
	> someone I follow adds a new photo to a collection <br><br>
	<input type="submit" value="Save">
</form>

<!-- 
<form id="settings" action="/delete" method="post">
	<input type="submit" value="Delete Profile">
	<input type="hidden" name="command" value="profile" />
	<input type="hidden" name="username" value="${fn:escapeXml(username)}">
</form>
-->

</body>
</html>