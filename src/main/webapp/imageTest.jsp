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
		String profileName = user.getNickname();
		String collectionName = "defaultCollection";
		
		pageContext.setAttribute("profileName", profileName);
		pageContext.setAttribute("collectionName", collectionName);
	%>

	<form action="<%=blobstoreService.createUploadUrl("/upload")%>" method="post" enctype="multipart/form-data">
		<input type="file" name="myFile"> 
		<input type="submit" value="Submit">
		<input type="hidden" name="profileName" value="${fn:escapeXml(profileName)}"/>
		<input type="hidden" name="collectionName" value="${fn:escapeXml(collectionName)}"/>
	</form>

	<%
		ObjectifyService.register(Profile.class);
		ObjectifyService.ofy().clear();
		List<Profile> profiles = ObjectifyService.ofy().load().type(Profile.class).list();
		for(Profile profile : profiles)
		{
			if(profile.getUser().equals(user))
			{
				ArrayList<Collection> collections = profile.getCollections();
				for(Collection collection : collections)
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
				}
		%>
			</div>
		<%
				//we are done displaying for the current profile
				break;
			}
		}
	%>
	<a href="profilePage.jsp" role="button">Back to My Profile</a>	
</body>
</html>