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
<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="/stylesheets/style.css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/scripts/browseScript.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Browse</title>
</head>
<body class="body">

<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		Profile profile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		String username = profile.getUsername();
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
		<h2 class="header">Browse Other Profiles</h2>
		<br>
		<br> 
		<input id="searchText" onkeyup="search()" class="form-control" type="text" name="search" placeholder="Search...">
		
		<div class="list-group" id="profileList">
		<%
		List<Profile> profiles = ObjectifyService.ofy().load().type(Profile.class).list();
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