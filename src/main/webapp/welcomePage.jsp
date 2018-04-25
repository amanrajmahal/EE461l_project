<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="java.util.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Collection Connection Home</title>
<style>
.center {
	text-align: center;
	align: center;
}
</style>
</head>
<body>
	<%
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user == null) {
	%>

	<div class="center" style="margin-top: 30%">
		<h1>Collection Connection</h1>
		<div>
			<p>Hello user!</p>
			<a class="btn btn-primary" href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign In</a>
		</div>
	</div>

	<%
		} else {
			Profile profile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
			if (profile != null) {
				pageContext.setAttribute("username", profile.getUsername());
	%>
	<div class="center">
		<h1>Collection Connection</h1>
		<div class="center">
			<p>Hello ${fn:escapeXml(username)}!</p>
			<a href="profilePage.jsp?username=${fn:escapeXml(username)}">My Profile</a>
			<br>
			<a style="margin-top: .8em" class="btn btn-primary" href="<%=userService.createLogoutURL(request.getRequestURI())%>">Sign Out</a>
			<br> <br> <br>
			<h2>Other Profiles</h2>
		</div>
	</div>
	<%
				List<Profile> profiles = ObjectifyService.ofy().load().type(Profile.class).list();
				for (Profile otherprofile : profiles) {
					if (!profile.equals(otherprofile)) {
						pageContext.setAttribute("username", otherprofile.getUsername());
	%>
	<div class="center">
		<a style="text-align: center;" href="profilePage.jsp?username=${fn:escapeXml(username)}">${fn:escapeXml(username)}</a>
	</div>
	<%
					}
				}
			} 
			else {
	%>
	<p class="center">Hello! Please input a Username below.</p>
	<form class="center" action="/profile" method="post">
		<input type="text" style="margin: auto; margin-bottom: 1em; width: 40%;"
			class="form-control center" name="username" placeholder="Username">
		<input type="submit" class="btn btn-success" value="Submit">
	</form>
	<%
			}
		}
	%>
</body>
</html>