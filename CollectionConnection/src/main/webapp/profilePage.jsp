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
<title>My Profile</title>
</head>
<body>
	<h1><%=UserServiceFactory.getUserService().getCurrentUser().getNickname()%></h1>
<% 
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
%>		
	<a href="imageTest.jsp" role="button">Add Collection</a>	
	<br>
	<br>
	<a href="welcomePage.jsp" role="button">Back to Home</a>	
</body>
</html>