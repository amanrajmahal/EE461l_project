<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Follower"%>
<%@ page import="collectionconnection.Collection"%>
<%@ page import="collectionconnection.CollectionNotificationText"%>
<%@ page import="collectionconnection.CommentNotificationText"%>
<%@ page import="collectionconnection.FollowerNotificationText"%>
<%@ page import="collectionconnection.PhotoNotificationText"%>
<%@ page import="collectionconnection.Photo"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto"> 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/css/lightbox.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/octicons/4.4.0/font/octicons.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/js/lightbox-plus-jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="/scripts/profileAddCollection.js"></script>

<title>My Profile</title>
</head>
<body id="body" class="body">
	<%
		BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String username = request.getParameter("username");
		pageContext.setAttribute("username", username);
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now(); // who the user is going to follow
		Profile myProfile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("actualUser", user).first().now(); // current user who is logged in
	%>
	<%
		if (profile != null) {
			Set<Ref<Follower>> followers = profile.getFollowers();
		if (!myProfile.getUsername().equals(profile.getUsername())) {
				String buttonValue = followers.contains(Ref.create(myProfile)) ? "Unfollow" : "Follow";
				pageContext.setAttribute("buttonValue", buttonValue);			
	%>
	<nav class="navbar navbar-expand-sm navbar-light bg-light">
		<a class="navbar-brand navbar-header" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">Collection Connection</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div class="collapse navbar-collapse" id="navbarSupportedContent">			
	    	<ul class="navbar-nav ml-auto justify-content-end">
		      	<li class="nav-item"><a class="nav-link" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">
		      		<span class="octicon octicon-person"></span> My Profile</a>
		      	</li>
		      	<li class="nav-item"><a class="nav-link" href="settings.jsp"><span class="octicon octicon-gear"></span> Settings</a></li>
		      	<li class="nav-item"><a class="nav-link" href="browse.jsp"><span class="octicon octicon-search"></span> Browse</a></li>
				<li class="nav-item"><a class="nav-link" role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="octicon octicon-sign-out"></span> Sign Out</a>
				</li>
			</ul>
		</div>
	</nav>
	<h1 class="header username-display">${fn:escapeXml(username)}</h1>
	<form  class ="header" action="/follower" method="post">			
	<input class ="btn btn-default"id = "followerTest" type="submit" value="${fn:escapeXml(buttonValue)}">
	<input type="hidden" name="username" value="${fn:escapeXml(username)}">
	</form>
	<%
		} else {
	%>
	
	<nav class="navbar navbar-expand-sm navbar-light bg-light">
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
		      	<li class="nav-item"><a class="nav-link" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">
		      		<span class="octicon octicon-person"></span> My Profile</a>
		      	</li>
		      	<li class="nav-item"><a class="nav-link" href="settings.jsp"><span class="octicon octicon-gear"></span> Settings</a></li>
		      	<li class="nav-item"><a class="nav-link" href="browse.jsp"><span class="octicon octicon-search"></span> Browse</a></li>
				<li class="nav-item"><a class="nav-link" role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="octicon octicon-sign-out"></span> Sign Out</a>
				</li>
			</ul>
		</div>
	</nav>
	
	<h1 class="header username-display" style="margin:10px auto;">${fn:escapeXml(username)}</h1>

	<%
		}
	%>
	<br>
	
	<div class="profileImageWrapper">
		<%
			if(profile.getProfilePhoto().getBlobKey() != null)
			{
				pageContext.setAttribute("profilePhoto", profile.getProfilePhoto().getBlobKey());
		%>	
					
						<img class="profileImage img-rounded" width="250" height="100" src="serve?blob-key=${fn:escapeXml(profilePhoto)}">
					
			
		<%
			}
			else
			{
		%>
			
						<img class="profileImage img-rounded" width="250" height="100" src="images/profileImage.png">
					
			
		<%
			}
		%>
	</div>
	<br><br><br>
	<h3 class="header">Collections</h3>
	<%
		ArrayList<Collection> collections = profile.getCollections();
	%>
		<div class="container text-center">
		<div class="row">
			<%
				for (Collection collection : collections) {
					pageContext.setAttribute("collection", collection.getCollectionName());
			%>
			<div class="col-sm-4">
				<div class="show-image">
					<%
						ArrayList<Photo> photos = collection.getPhotos();
						if (!photos.isEmpty()) {
							pageContext.setAttribute("blobkey", photos.get(0).getBlobKey());
							pageContext.setAttribute("photoname", photos.get(0).getName());
					%>
					<a href="collectionPage.jsp?username=${fn:escapeXml(username)}&collection=${fn:escapeXml(collection)}"role="button">
					<img width="200" height="150" class="img-rounded" src="serve?blob-key=${fn:escapeXml(blobkey)}">
					</a>
					
					<%
						}
						else
						{
					%>
					<a href="collectionPage.jsp?username=${fn:escapeXml(username)}&collection=${fn:escapeXml(collection)}" role="button">
					<img width="200" height="150" class="img-rounded" src="images/defaultImage.gif">
					</a>
					<%
						}
					%>
					<p>
						<strong><a href="collectionPage.jsp?username=${fn:escapeXml(username)}&collection=${fn:escapeXml(collection)}"
							role="button"> ${fn:escapeXml(collection)} </a></strong>
					</p>
					<%
						if(myProfile.equals(profile))
						{
					%>
					<form action ="/delete" method = "post">
						<input class="btn-danger btn btn-xs" type="submit" value="X" />
						<input type="hidden" name="command" value="collection" />
						<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
						<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
					</form>
					<%
						}
					%>
				</div>
			</div>

			<%
				}
		}
			%>
		</div>
	</div>
	<br>
	<br>
</body>
</html>