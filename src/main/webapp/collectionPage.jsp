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
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/stylesheets/style.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto"> 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/css/lightbox.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/octicons/4.4.0/font/octicons.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/js/lightbox-plus-jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
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
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand navbar-header" href="profilePage.jsp?username=<%=profile.getUsername()%>">Collection Connection</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div class="collapse navbar-collapse" id="navbarSupportedContent">

		<ul class="navbar-nav mr-auto my-auto form-inline justify-content-end">
	    	
	<% 
		if(myProfile.equals(profile))
		{
	%>
			<li class="nav-item nav-link"><label style=""for="fileIn">
				<span class="octicon octicon-plus"></span> File Upload
			</label></li>
			</ul>
	<%
		}
	%>
				<ul class="navbar-nav ml-auto justify-content-end">
		      	<li class="nav-item"><a class="nav-link" href="profilePage.jsp?username=<%=myProfile.getUsername()%>">
		      		<span class="octicon octicon-person"></span> My Profile</a>
		      	</li>
		      	<li class="nav-item"><a class="nav-link" href="settings.jsp"><span class="octicon octicon-gear"></span> Settings</a></li>
		      	<li class="nav-item"><a class="nav-link" href="browse.jsp"><span class="octicon octicon-search"></span> Browse</a></li>
				<li class="nav-item"><a class="nav-link" role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="octicon octicon-sign-out"></span> Sign Out</a>
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

						String profileImage = profileOfComment.getProfilePhoto().getBlobKey() == null ? "images/profileImage.png" : "serve?blob-key=" + profileOfComment.getProfilePhoto().getBlobKey();
						
						pageContext.setAttribute("timeElapsed", comment.getDate().toString());
						pageContext.setAttribute("profileImageKey", profileImage);
						pageContext.setAttribute("comment", comment.getComment());
						pageContext.setAttribute("commentId",comment.getCommentId());
						pageContext.setAttribute("usernameOfComment", profileOfComment.getUsername());
		%>

				<div style="align:center;margin:auto;width:50%;">
					<div style="width:100%;">
			            <div class="panel panel-white post panel-shadow">
			                <div class="post-heading">
			                
			                				<%
					if(myProfile.equals(profile) || myProfile.equals(profileOfComment)) {
			%>
					<form style = "float: right;" id="commentForm" action ="/delete" method = "post">
						<input class="btn btn-danger btn-xs" type="submit" value="X" />
						<input type="hidden" name="command" value="comment" />
						<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
						<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
						<input type="hidden" name="commentId" value="${fn:escapeXml(commentId)}" />
					</form>
			<%
					}
			%>
			                    <div class="pull-left image">
			                        <img src="${fn:escapeXml(profileImageKey)}" class="img-circle avatar" alt="user profile image">
			                    </div>
			                    <div class="pull-left meta">
			                        <div class="title h5">
			                            <a href="/profilePage.jsp?username=${fn:escapeXml(usernameOfComment)}"><b>${fn:escapeXml(usernameOfComment)}</b></a>
			                            made a comment.
			                        </div>
			                        <h6 class="text-muted time">${fn:escapeXml(timeElapsed)}</h6>
			                    </div>
			                </div> 
			                <div style="word-wrap:break-word;" class="post-description"> 
			                    <p>${fn:escapeXml(comment)}</p>
			                </div>
			            </div>
					</div>
				</div>
		<%
				}
			}
		}
	%>
</body>
</html>