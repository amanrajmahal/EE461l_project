<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Follower"%>
<%@ page import="collectionconnection.Collection"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>My Profile</title>
</head>
<body>
	<% 
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String desiredProfile = request.getParameter("targetProfile");
		pageContext.setAttribute("currentProfile", desiredProfile);
		ObjectifyService.ofy().clear();
		Profile targetProfile = ObjectifyService.ofy().load().type(Profile.class).filter("username", desiredProfile).first().now();	// who the user is going to follow
		ObjectifyService.ofy().clear();
		Profile userProfile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now(); // current user who is logged in
		if(targetProfile != null)
		{
			Set<Ref<Follower>> followers = targetProfile.getFollowers();
			pageContext.setAttribute("username", targetProfile.getUsername());
			%>
			<h1> ${fn:escapeXml(username)} </h1>
			<%
			if (!userProfile.getUsername().equals(targetProfile.getUsername()))
			{
				System.out.println("userProfile: " + userProfile + "\ntargetProfile: " + targetProfile);
				String buttonValue = followers.contains(Ref.create(userProfile)) ? "Unfollow" : "Follow";
				//String buttonValue = "Follow";
				//if(followers.contains(Ref.create(userProfile)))
				//{
					//buttonValue = "Unfollow";
				//}
				pageContext.setAttribute("buttonValue", buttonValue);
	%>
	<form action="/follower" method="post">
	    <div><input type="submit" value="${fn:escapeXml(buttonValue)}"/></div>
	    <input type="hidden" name="profileToAdd" value="${fn:escapeXml(username)}"/>
	</form>
	
	<% 
			}
			else
			{
				%>
				<form action="/collection" method="post">
					<div><input name="collection"/></div>
	   	 			<div><input type="submit" value="Add Collection"/></div>
	    			<input type="hidden" name="username" value="${fn:escapeXml(username)}"/>
	    			<input type="hidden" name="currentProfile" value="${fn:escapeXml(currentProfile)}"/>
				</form>
				<br>
				<% 
			}
			
			%>
			<h1> Collections </h1>
			<%
			ArrayList<Collection> collections = targetProfile.getCollections();
				
			for(Collection collection : collections)
			{
				pageContext.setAttribute("collectionName", collection.getCollectionName());
				%>
					<a href="imageTest.jsp?collectionName=${fn:escapeXml(collectionName)}&targetProfile=${fn:escapeXml(currentProfile)}" role="button"> ${fn:escapeXml(collectionName)} </a>
					<br>
				<%
			}
	%>
	<br>
	<br>
	<a href="welcomePage.jsp" role="button">Back to Home</a>
	<% 
			System.out.println("RELOADING");
			for(Ref<Follower> follower : followers)
			{
				System.out.println(((Profile)follower.get()).getUsername());
			}
		}
	%>
</body>
</html>