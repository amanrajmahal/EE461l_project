<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Collection"%>
<%@ page import="collectionconnection.CollectionNotificationText"%>
<%@ page import="collectionconnection.CommentNotificationText"%>
<%@ page import="collectionconnection.FollowerNotificationText"%>
<%@ page import="collectionconnection.PhotoNotificationText"%>
<%@ page import="collectionconnection.Photo"%>
<%@ page import="collectionconnection.Comment"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link type="text/css" rel="stylesheet" href="/stylesheets/style.css" />
<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/css/lightbox.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/js/lightbox-plus-jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="/scripts/collectionScript.js"></script>
<title>Collection</title>
</head>
<body class="body">
	<%
		BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
		ObjectifyService.register(Profile.class);
		ObjectifyService.register(CollectionNotificationText.class);
		ObjectifyService.register(CommentNotificationText.class);
		ObjectifyService.register(FollowerNotificationText.class);
		ObjectifyService.register(PhotoNotificationText.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String collectionName = request.getParameter("collection");
		String username = request.getParameter("username");
		pageContext.setAttribute("username", username);
		pageContext.setAttribute("collection", collectionName);
		//ObjectifyService.ofy().clear();

		Profile profile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("username", username).first().now();
		//ObjectifyService.ofy().clear();
		Profile myProfile = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("actualUser", user).first().now();
	%>
	
		<nav class="navbar navbar-default">
		<div class="container-fluid">
			<a class="navbar-brand navbar-header" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">Collection Connection</a>
			<div style="align:center">
	<% 
		if(myProfile.equals(profile))
		{
	%>
			<ul class="nav navbar-nav">
			<li><a><label style="font-weight:normal;"for="fileIn" class="nav navbar-nav">
					<span class="glyphicon glyphicon-plus-sign"></span>  File Upload
			</label></a></li>
			</ul>
	<%
		}
	%>
			</div>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="profilePage.jsp?username=<%=myProfile.getUsername()%>"><span class="glyphicon glyphicon-user"></span> My Profile</a></li>
				<li><a href="settings.jsp"><span class="glyphicon glyphicon-cog"></span> Settings</a></li>
				<li><a href="browse.jsp"><span class="glyphicon glyphicon-search"></span> Browse</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="glyphicon glyphicon-log-out"></span> Sign Out</a>
				</li>
			</ul>
		</div>
	</nav>
	
	<%
		if (myProfile.equals(profile)) {
	%>
	<form id="form" action="<%=blobstoreService.createUploadUrl("/upload")%>"
		method="post" enctype="multipart/form-data">
		<input type="file" id="fileIn" name="myFile" accept="image/*"
				onchange="javascript:this.form.submit();">
		<input type="hidden" name="collectionName" value="${fn:escapeXml(collection)}" />
	</form>

	<%
		}
		if (profile != null) {
			Collection collection = profile.findCollection(collectionName);
			if (collection != null) {
				pageContext.setAttribute("collection", collection.getCollectionName());
	%>
		<h1 align="center"><b>${fn:escapeXml(collection)}</b></h1>
		<div class="container text-center">
		<div class="row">
		<%
			ArrayList<Photo> photos = collection.getPhotos();
					for (Photo photo : photos) {
						pageContext.setAttribute("blobkey", photo.getBlobKey());
						pageContext.setAttribute("photoname", photo.getName());
		%>
			<div class="col-sm-4">
			<div class="show-image">
			<a href = "serve?blob-key=${fn:escapeXml(blobkey)}" data-lightbox="${fn:escapeXml(collection)}">
				<img width="250" height="150" title="${fn:escapeXml(photoname)}" src="serve?blob-key=${fn:escapeXml(blobkey)}">
			</a>
		<%
						if(myProfile.equals(profile))
						{
		%>
				<form action ="/delete" method = "post">
					<input class="btn btn-danger btn-xs" type="submit" value="X" />
					<input type="hidden" name="command" value="photo" />
					<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
					<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
					<input type="hidden" name="photo" value="${fn:escapeXml(blobkey)}" />
				</form>
		<%
						}
		%>
			</div>
			
			</div>
		<%
					}
		%>
		</div>	
		</div>
		<% 

			pageContext.setAttribute("username", profile.getUsername());
		%>
		<br><br><br>
		<h3 align="center">Comments</h3>
		<form class="center" style="margin:auto;margin-bottom:53px;width:50%" action="/comment" method="post">
			<textarea name="comment" id="txtArea" class="form-control form-horizontal" placeholder="Comment here..." rows="1"></textarea>
			<input type="submit"  id="txtSub"  value="Post comment" style="margin-top:10px;float:right" class="btn btn-success"   disabled>
			<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
			<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
		</form>
		<br>
		
		<%
			//pull up comments for this profile and this collection
					ArrayList<Comment> comments = collection.getComments();
					Collections.sort(comments);

					for (Comment comment : comments) {
						//ObjectifyService.ofy().clear();
						Profile profileOfComment = ObjectifyService.ofy().load().type(Profile.class).ancestor(Key.create(Profile.class, "profiles")).filter("actualUser", comment.getUser()).first().now();

						pageContext.setAttribute("comment", comment.getComment());
						pageContext.setAttribute("commentId",comment.getCommentId());
						pageContext.setAttribute("usernameOfComment", profileOfComment.getUsername());
		%>

				<div  style="align:center;margin:auto;margin-bottom:53px;width:50%">
				
				<div class ="show-image"style ="width:100%">
				
					<b>${fn:escapeXml(usernameOfComment)}: </b>${fn:escapeXml(comment)}				
					
			<%
					if(myProfile.equals(profile) || myProfile.equals(profileOfComment)) {
			%>
					<form id="commentForm" action ="/delete" method = "post">
						<input class="btn btn-default btn-xs" type="submit" value="x" style = "margin-left:10px"/>
						<input type="hidden" name="command" value="comment" />
						<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
						<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
						<input type="hidden" name="commentId" value="${fn:escapeXml(commentId)}" />
					</form>
			<%
					}
			%>
			
				</div>
				</div>
		<%
				}
			}
		}
	%>
</body>
</html>