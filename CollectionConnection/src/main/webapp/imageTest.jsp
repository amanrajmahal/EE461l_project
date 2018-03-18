<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
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
		String profileName = "NickShlapkou";
		String collectionName = "StampsAndStars";
		
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
		ObjectifyService.register(Photo.class);
		List<Photo> photos = ObjectifyService.ofy().load().type(Photo.class).list();
		Collections.sort(photos);
		for(Photo photo : photos)
		{
			if(profileName.equals(photo.getProfileName()) && collectionName.equals(photo.getCollectionName()))
			{
				pageContext.setAttribute("blobkey", photo.getBlobKey());
	%>
					<img width="200" height="150" src = "serve?blob-key=${fn:escapeXml(blobkey)}">
	<% 
			}
		}
	%>
	<a href="profilePage.jsp" role="button">Back to My Profile</a>	
</body>
</html>