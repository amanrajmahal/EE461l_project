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
<!--  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"> -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
$(document).ready(function(){
	$("#body").css("background-color","lavender");
    $("#follow").click(function(){
    	
    });
});

</script>

<title>My Profile</title>
</head>
<body id = "body">
<%
	UserService userService = UserServiceFactory.getUserService();
%>
	<nav class="navbar navbar-default" style = "background-color:lavender">
  		<div class="container-fluid">
    		<div class="navbar-header">
      	<a class="navbar-brand" href="welcomePage.jsp" style = "background-color:lavender">Collection Connection</a>
    	</div>
    	<ul class="nav navbar-nav" style = "background-color:lavender">
      		<li class="active" ><a style = "background-color:lavender" href="welcomePage.jsp">Home</a></li>
      		<li class="active"><a style = "background-color:lavender" href="imageTest.jsp">Add Collection</a></li>
      		<li><a style = "background-color:lavender" href="<%= userService.createLogoutURL(request.getRequestURI()) %>">Sign Out</a></li>
      		 
    	</ul>
  		</div>
	</nav>
	<% 
		ObjectifyService.register(Profile.class);
		
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
			<h3 style ="color:green" style = "font-family: serif" style = "text-align:center"> ${fn:escapeXml(username)} </h3>
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
	
	
		<button id = "follow">${fn:escapeXml(buttonValue)}</button>
	<% 
			}
			else
			{
				%>
				 <!-- <form action="/collection" method="post">
					<div><input name="collection"/></div>
	   	 			<div><input type="submit" value="Add Collection"/></div>
	    			<input type="hidden" name="username" value="${fn:escapeXml(username)}"/>
	    			<input type="hidden" name="currentProfile" value="${fn:escapeXml(currentProfile)}"/>
				</form> -->
				<br>
				<% 
			}
			
			%>							
			<h3 style ="color:green" style = "font-family: serif" style = "text-align:center"> Collections </h3>
			<%
			ArrayList<Collection> collections = targetProfile.getCollections();
			%>
			<div class = "container">
				<div class="row">
			<%			  	
			for(Collection collection : collections)
			{
				pageContext.setAttribute("collectionName", collection.getCollectionName());
				%>	<div class="col-sm-4" style="background-color:lavender;">
					<a href="imageTest.jsp?collectionName=${fn:escapeXml(collectionName)}&targetProfile=${fn:escapeXml(currentProfile)}" role="button"> ${fn:escapeXml(collectionName)} </a>
					</div>
					<br>
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
			for(Ref<Follower> follower : followers)
			{
				System.out.println(((Profile)follower.get()).getUsername());
			}
		}
	%>
</body>
</html>