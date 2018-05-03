<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Notification"%>
<%@ page import="collectionconnection.NotificationType"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="/stylesheets/style.css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/scripts/profileAddCollection.js"></script>
<script src="/scripts/collectionScript.js"></script>
<title>Settings</title>
</head>
<body class="body">
<%
		BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("actualUser", user).first().now();
		String username = profile.getUsername();
		Notification notificationSettings = profile.getNotification();
		String blobKey = profile.getProfilePhoto().getBlobKey();
		pageContext.setAttribute("username", username);
		pageContext.setAttribute("profilePhoto", blobKey);
		
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
				<input name="collectionButton" type="submit" class="btn btn-default" value="Add Collection" disabled>
			</form>
		</div>
	</nav>


<h2 class="header">Settings</h2>
<br><br>
<br><br>

<form id="form" action="<%=blobstoreService.createUploadUrl("/profilephoto")%>"
	method="post" enctype="multipart/form-data">
	<input type="file" id="fileIn" name="myFile" accept="image/*"
			onchange="javascript:this.form.submit();">
	<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
</form>

<div class = "profileImageWrapper">
<%
	if(blobKey != null)
	{
%>
	<a href = "serve?blob-key=${fn:escapeXml(profilePhoto)}" data-lightbox="${fn:escapeXml(username)}">
		<img class = "profileImage" style="align:center;text-align:center;margin:auto;display:block;" width="250" height="150" src="serve?blob-key=${fn:escapeXml(profilePhoto)}">
	</a>
<%
	}
	else
	{
%>
	<a href = "images/profileImage.png" data-lightbox="${fn:escapeXml(username)}">
		<img class = "profileImage" style="align:center;text-align:center;margin:auto;display:block;" width="250" height="150" src="images/profileImage.png">
	</a>
<%
	}
%>
</div>
<br>
<div style="margin:auto;text-align:center;align:center;">
	<a ><label style="font-weight:normal;margin:auto;"for="fileIn">
		<span class="glyphicon glyphicon-plus-sign"></span>  Change Profile Picture
	</label></a>
</div>
<br><br>
<div id="settingsLayout">
	<div id="settings">
		<form action="/settings" method="post">
			
			<label class="radio-inline">
		    	<input type="radio" name="type" value="none"
		    <%
		    	if(notificationSettings.getNotificationType() == NotificationType.NONE)
		    	{
		    %>
		    		checked
		    <%
		    	}
		    %>
		    	/> Turn off notifications</label>
			<label class="radio-inline">
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
			<label class="radio-inline">
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
			<h3>Notify me when...</h3>
			<div class="checkbox">
			<label><input type="checkbox" name="getCollections" value="collections"
			<%
		    	if(notificationSettings.includeCollections())
		    	{
		    %>
		    		checked
		    <%
		    	}
		    %>
			> someone I follow adds a new collection</label><br>
			</div>
			<div class="checkbox">
			<label><input type="checkbox" name="getPhotos" value="photos"
			<%
		    	if(notificationSettings.includePhotos())
		    	{
		    %>
		    		checked
		    <%
		    	}
		    %>
			> someone I follow adds a new photo to a collection</label><br>
			</div>
			<div class="checkbox">
			<label><input type="checkbox" name="getFollowers" value="followers"
			<%
		    	if(notificationSettings.includeFollowers())
		    	{
		    %>
		    		checked
		    <%
		    	}
		    %>
			> someone follows me</label><br><br>
			</div>
			<input class="btn btn-default" type="submit" value="Save">
		</form>
	</div>
</div>
<!-- 
<form id="settings" action="/delete" method="post">
	<input type="submit" value="Delete Profile">
	<input type="hidden" name="command" value="profile" />
	<input type="hidden" name="username" value="${fn:escapeXml(username)}">
</form>
-->

</body>
</html>