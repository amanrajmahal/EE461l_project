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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto"> 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/css/lightbox.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/js/lightbox-plus-jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
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
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand navbar-header" href="profilePage.jsp?username=<%=profile.getUsername()%>">Collection Connection</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<form class="my-auto form-inline" action="/collection" method="post"><!-- Collection Button -->
				<div class="input-group">
					<input class="form-control" type="text" name="collection" placeholder="Collection Name">
					<input type="hidden" name="username" value="${fn:escapeXml(username)}">
					<div class="input-group-append">
						<button class="btn btn-default" name="collectionButton" type="submit" disabled>Add Collection</button>
					</div>
				</div>
			</form>

			
	    	<ul class="navbar-nav ml-auto justify-content-end">
		      	<li class="nav-item"><a class="nav-link" href="profilePage.jsp?username=<%=profile.getUsername()%>">
		      		<span class="glyphicon glyphicon-user"></span> My Profile</a>
		      	</li>
		      	<li class="nav-item"><a class="nav-link" href="settings.jsp"><span class="glyphicon glyphicon-cog"></span> Settings</a></li>
		      	<li class="nav-item"><a class="nav-link" href="browse.jsp"><span class="glyphicon glyphicon-search"></span> Browse</a></li>
				<li class="nav-item"><a class="nav-link" role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="glyphicon glyphicon-log-out"></span>Sign Out</a>
				</li>
			</ul>
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