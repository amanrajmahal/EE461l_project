<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Collection"%>
<%@ page import="collectionconnection.Photo"%>
<%@ page import="collectionconnection.Comment"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>


<html>
<head>
<title>Upload Test</title>
</head>
<body>

	
	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String collectionName = request.getParameter("collectionName");
		String desiredProfile = request.getParameter("targetProfile");
		ObjectifyService.register(Profile.class);
		ObjectifyService.ofy().clear();
		
		Profile profile;
		System.out.println("Desired profile: " + desiredProfile);
		if(desiredProfile != null && desiredProfile.length() > 0)
		{
			//pull up desired one
			profile = ObjectifyService.ofy().load().type(Profile.class).filter("username", desiredProfile).first().now();
		}
		else
		{
			//pull up your own 
			profile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		}
		
		Profile userProfile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		
		pageContext.setAttribute("collectionName", collectionName);
		
		if(userProfile.equals(profile))
		{
			%>
		
			<form action="<%=blobstoreService.createUploadUrl("/upload")%>" method="post" enctype="multipart/form-data">
				<input type="file" name="myFile"> 
				<input type="submit" value="Submit">
				<input type="hidden" name="collectionName" value="${fn:escapeXml(collectionName)}"/>
			</form>
		
			<%
		}
		if(profile != null)
		{   
			Collection collection = profile.findCollection(collectionName);
			if(collection != null)
			{
				pageContext.setAttribute("collectionname", collection.getCollectionName());
			%>
							<div>
								<h1>${fn:escapeXml(collectionname)}</h1>
			<% 
				ArrayList<Photo> photos = collection.getPhotos();
				for(Photo photo : photos)
				{
					pageContext.setAttribute("blobkey", photo.getBlobKey());
					pageContext.setAttribute("photoname", photo.getName());				
			%>
								<img width="200" height="150" title = "${fn:escapeXml(photoname)}" src = "serve?blob-key=${fn:escapeXml(blobkey)}">
			<% 
				}
				
				pageContext.setAttribute("username", profile.getUsername());	
				%>			
				<form action="/comment" method="post">
			      <h1> Comments </h1>
			      <div><textarea name = "comment" placeholder="My comment here..." rows="1" cols="30"></textarea></div>
			      <div><input class="btn btn-outline-success" type="submit" value="Post Blog" onclick="return checkEmpty()"/></div>
			      <input type="hidden" name="username" value="${fn:escapeXml(username)}"/>
			      <input type="hidden" name="collection" value="${fn:escapeXml(collectionName)}"/>
			    </form>
			    <%
				
				//pull up comments for this profile and this collection
	   			ArrayList<Comment> comments = collection.getComments();
	   			
	   			for(Comment comment : comments)
	   			{
	   				Profile profileOfComment = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", comment.getUser()).first().now();
	   				
	   				pageContext.setAttribute("comment", comment.getComment());
	   				pageContext.setAttribute("usernameOfComment", profileOfComment.getUsername());
	   				%>
	   					<div>
	   						<div><p><b>${fn:escapeXml(usernameOfComment)}: </b>${fn:escapeXml(comment)} </p></div>
	   					</div>
	   				<%
	   			}
			}
		%>
		</div>
	    <%
	    	
		}	
		 %>
	<a href="profilePage.jsp?targetProfile=${fn:escapeXml(username)}" role="button">Back to My Profile</a>	
</body>
</html>