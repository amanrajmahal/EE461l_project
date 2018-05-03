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
<%
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" rel="stylesheet" href="/stylesheets/style.css" />
<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet"> 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/scripts/profileAddCollection.js"></script>
<script>
	$(document).ready(function() {
		//$("#body").css("background-color","lavender");
		$("#follow").click(function() {

		});
	});
</script>

<title>My Profile</title>
</head>
<body id="body" class="body">
	<%
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String username = request.getParameter("username");
		pageContext.setAttribute("username", username);
		//ObjectifyService.ofy().clear();
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now(); // who the user is going to follow
		//ObjectifyService.ofy().clear();
		Profile myProfile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("actualUser", user).first().now(); // current user who is logged in
	%>
	<%
		if (profile != null) {
			Set<Ref<Follower>> followers = profile.getFollowers();
	%>
	<%
		if (!myProfile.getUsername().equals(profile.getUsername())) {
				//System.out.println("userProfile: " + myProfile + "\ntargetProfile: " + profile);
				String buttonValue = followers.contains(Ref.create(myProfile)) ? "Unfollow" : "Follow";
				pageContext.setAttribute("buttonValue", buttonValue);			
	%>
	<script type="text/javascript">
	
	document.getElementById("followerTest").value = buttonValue
	
	</script>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">Collection Connection</a>
			</div>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="profilePage.jsp?username=<%=myProfile.getUsername()%>"><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
				<li><a href="settings.jsp"><span class="glyphicon glyphicon-cog"></span> Settings</a></li>
				<li><a href="browse.jsp"><span class="glyphicon glyphicon-search"></span> Browse</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="glyphicon glyphicon-log-out"></span>
					Sign Out</a>
				</li>
			</ul>
			
			<form class="navbar-form navbar-right" id = "followNav"action="/follower" method="post">
				<div class="form-group">
				<!-- 	<input id = "followerTest" type="submit" value="${fn:escapeXml(buttonValue)}">-->
					<input type="hidden" name="username" value="${fn:escapeXml(username)}">
				</div>
				<input id = "followerTest" type="submit" class="btn btn-default" value="${fn:escapeXml(buttonValue)}">
			</form>
			<p class="navbar-text" id = "userNav"> <b>${fn:escapeXml(username)}</b> </p>
			
		</div>
	</nav>
	
	<!--  <form action="/follower" method="post">
	    	<input id="followerTest" type="submit" value="${fn:escapeXml(buttonValue)}"/>
	    	<input type="hidden" name="username" value="${fn:escapeXml(username)}"/>
	</form>-->
	<%
		} else {
	%>
	
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<a class="navbar-brand navbar-header" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">Collection Connection</a>	
			<ul class="nav navbar-nav navbar-right">
	<% 
		if(myProfile.equals(profile))//If user == profile's user, show button
		{
	%>
				<li><a><label style="font-weight:normal;"for="fileIn" class="nav navbar-nav">
						<span class="glyphicon glyphicon-plus-sign"></span>  Edit Photo
				</label></a></li>
	<%
		}
	%>
				<li><a href="profilePage.jsp?username=<%=myProfile.getUsername()%>"><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
				<li><a href="settings.jsp"><span class="glyphicon glyphicon-cog"></span> Settings</a></li>
				<li><a href="browse.jsp"><span class="glyphicon glyphicon-search"></span> Browse</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="glyphicon glyphicon-log-out"></span>
					Sign Out</a>
				</li>
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
	<% 
		if(myProfile.equals(profile))
		{
	%>
	<form id="form" action="<%=blobstoreService.createUploadUrl("/profilephoto")%>"
		method="post" enctype="multipart/form-data">
		<input type="file" id="fileIn" name="myFile" accept="image/*"
				onchange="javascript:this.form.submit();">
		<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
	</form>
	<%
		}
	%>
	
	<h2 class="header">My Profile</h2>
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
					<a href = "serve?blob-key=${fn:escapeXml(profilePhoto)}" data-lightbox="${fn:escapeXml(username)}">
						<img class="profileImage" width="250" height="150" src="serve?blob-key=${fn:escapeXml(profilePhoto)}">
					</a>
		<%
			}
			else
			{
		%>
					<a href = "images/profileImage.png" data-lightbox="${fn:escapeXml(username)}">
						<img class="profileImage" width="250" height="150" src="images/profileImage.png">
					</a>
		<%
			}
		%>
	</div>
	<h2 class="header">Collections</h2>
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
						<input class="the-buttons" type="submit" value="X" />
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
			%>
		</div>
	</div>
	<br>
	<br>
	<%
			for (Ref<Follower> follower : followers) {
				System.out.println(((Profile) follower.get()).getUsername());
			}
		}
	%>
</body>
</html>