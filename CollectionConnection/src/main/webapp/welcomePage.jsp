<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.*" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Collection Connection Home</title>
</head>
<body>
	<h1>Collection Connection</h1>
<% 
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user == null) {
%>		
		<a class="accountbutton btn btn-secondary btn-sm" href="<%=userService.createLoginURL(request.getRequestURI()) %>" role="button">Sign In</a>
		<br>
		<br>

<% 
	} else { %>
		<a class="accountbutton btn btn-secondary btn-sm" href="<%=userService.createLogoutURL(request.getRequestURI()) %>" role="button">Sign Out</a>
		<br>
		<br>
		<a href="profilePage.jsp">My Profile</a>
<%
	}
%>
</body>
</html>