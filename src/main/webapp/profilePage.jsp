<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Follower"%>
<%@ page import="collectionconnection.Collection"%>
<%@ page import="collectionconnection.Photo"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<!--  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"> -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
	$(document).ready(function() {
		//$("#body").css("background-color","lavender");
		$("#follow").click(function() {

		});
	});
</script>

<title>My Profile</title>
</head>
<body id="body" style="margin:10px">
	<%
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String username = request.getParameter("username");
		pageContext.setAttribute("username", username);
		ObjectifyService.ofy().clear();
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).filter("username", username).first().now(); // who the user is going to follow
		ObjectifyService.ofy().clear();
		Profile myProfile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now(); // current user who is logged in
	%>
	<%
		if (profile != null) {
			Set<Ref<Follower>> followers = profile.getFollowers();
	%>
	<h3 style="color: green; font-family: serif; text-align: center">${fn:escapeXml(username)}</h3>
	<%
		if (!myProfile.getUsername().equals(profile.getUsername())) {
				//System.out.println("userProfile: " + myProfile + "\ntargetProfile: " + profile);
				String buttonValue = followers.contains(Ref.create(myProfile)) ? "Unfollow" : "Follow";
				pageContext.setAttribute("buttonValue", buttonValue);
	%>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<div class="navbar-header">
				<a class="navbar-brand" href="welcomePage.jsp">Collection Connection</a>
			</div>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="profilePage.jsp?username=<%=myProfile.getUsername()%>">My Profile</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">Sign Out</a></li>
			</ul>
		</div>
	</nav>
	
	<form action="/follower" method="post">
	    	<input type="submit" value="${fn:escapeXml(buttonValue)}"/>
	    	<input type="hidden" name="username" value="${fn:escapeXml(username)}"/>
	</form>
	<%
		} else {
	%>
	<!-- <form action="/collection" method="post">
					<div><input name="collection"/></div>
	   	 			<div><input type="submit" value="Add Collection"/></div>
	    			<input type="hidden" name="username" value="${fn:escapeXml(username)}"/>
	    			<input type="hidden" name="currentProfile" value="${fn:escapeXml(currentProfile)}"/>
				</form> -->
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<a class="navbar-brand navbar-header" href="welcomePage.jsp">Collection Connection</a>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="profilePage.jsp?username=<%=myProfile.getUsername()%>">My Profile</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">Sign Out</a></li>
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
	<br>
	<%
		}
	%>
	<h3 style="color: green; font-family: serif; text-align: center">Collections</h3>
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
				<%
					ArrayList<Photo> photos = collection.getPhotos();
							if (!photos.isEmpty()) {
								pageContext.setAttribute("blobkey", photos.get(0).getBlobKey());
								pageContext.setAttribute("photoname", photos.get(0).getName());
				%>
				<!-- <a href="collectionPage.jsp?targetProfile=${fn:escapeXml(currentProfile)}&collectionName=${fn:escapeXml(collectionName)}" role="button"> ${fn:escapeXml(collectionName)} </a>-->
				<img width="200" height="150" class="img-rounded" src="serve?blob-key=${fn:escapeXml(blobkey)}">
				<%
					}
				%>
				<p>
					<strong><a href="collectionPage.jsp?username=${fn:escapeXml(username)}&collection=${fn:escapeXml(collection)}"
						role="button"> ${fn:escapeXml(collection)} </a></strong>
				</p>
			</div>

			<%
				}
			%>
		</div>
	</div>
	<br>
	<br>
	<!--  
	<a href="welcomePage.jsp" role="button">Back to Home</a> -->
	<%
		System.out.println("RELOADING");
			for (Ref<Follower> follower : followers) {
				System.out.println(((Profile) follower.get()).getUsername());
			}
		}
	%>
</body>
</html>