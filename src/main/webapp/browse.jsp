<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="java.util.*"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
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
<script src="/scripts/browseScript.js"></script>
<script src="/scripts/profileAddCollection.js"></script>
<title>Browse</title>
</head>
<body class="body">

<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("actualUser", user).first().now();
		String username = profile.getUsername();
		pageContext.setAttribute("username", username);
		
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
	<h2 class="header">Browse Other Profiles</h2>
	<br>
	<br> 
	<input id="searchText" onkeyup="search()" class="form-control" type="text" name="search" placeholder="Search...">

	<div class="list-group" id="profileList">
	<%
	List<Profile> profiles = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).list();
	for (Profile otherprofile : profiles) {
		if (!profile.equals(otherprofile)) {
			pageContext.setAttribute("username", otherprofile.getUsername());
	%>
		<a class="list-group-item center" style="width:50%;margin:auto;" href="profilePage.jsp?username=${fn:escapeXml(username)}">${fn:escapeXml(username)}</a>
	<% 				
		}
	}
	%>
	</div>
</body>
</html>