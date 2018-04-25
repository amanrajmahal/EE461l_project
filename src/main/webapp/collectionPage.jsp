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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
$(document).ready(function(){
	//$("#body").css("background-color","black");
});
</script>
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
			<script type="text/javascript">
				$(document).ready(
					    function(){
					        $('input:file').change(
					            function(){
					                if ($(this).val()) {
					                    $('#fileSub').attr('disabled',false);
					                    // or, as has been pointed out elsewhere:
					                    // $('input:submit').removeAttr('disabled'); 
					                } 
					            }
					            );
							$("#txtArea").keypress( 
								function(){
									if($("#txtArea").val().trim().length < 1){
										$('#txtSub').attr('disabled',true);
									}else{
										$('#txtSub').attr('disabled',false);
									}
								}
								
							)
					    });

			</script>
			<nav class="navbar navbar-default">
	  		<div class="container-fluid">
	    		<div class="navbar-header">
	      	<a class="navbar-brand" href="welcomePage.jsp" style = >Collection Connection</a>
	    	</div>
	    		<ul class="nav navbar-nav" style = >
	      		<li class="active" ><a href="welcomePage.jsp">Home</a></li>
	      		<li class="active"><a href="profilePage.jsp?targetProfile=">Back to My Profile BROKEN</a></li>
	      		<!-- <li><a href="#">Page 2</a></li>
	      		<li><a href="#">Page 3</a></li> -->
	    		</ul>
	  			</div>
			</nav>
			<form action="<%=blobstoreService.createUploadUrl("/upload")%>" method="post" enctype="multipart/form-data">
				<input type="file" name="myFile" accept="image/*"> 
				<input class="btn btn-success" type="submit" id="fileSub" value="Submit" disabled>
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
				<img width="200" height="150" title = "${fn:escapeXml(photoname)}" 
					src = "serve?blob-key=${fn:escapeXml(blobkey)}">
			<% 
				}
				
				pageContext.setAttribute("username", profile.getUsername());	
				%>			
				<form action="/comment" method="post">
			      <h1> Comments </h1>
			      <div><textarea name = "comment" id="txtArea" placeholder="My comment here..." rows="1" cols="30"></textarea></div>
			      <div><input class="btn btn-success" id="txtSub" type="submit" value="Post comment" disabled></div>
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