<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="collectionconnection.Profile"%>
<%@ page import="collectionconnection.Collection"%>
<%@ page import="collectionconnection.Photo"%>
<%@ page import="collectionconnection.Comment"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>


<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/css/lightbox.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.10.0/js/lightbox-plus-jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script>
	$(document).ready(function() {
		//$("#body").css("background-color","black");
	});
</script>
<style>
#fileIn{
    display: none;
}
.center {
	text-align: center;
	align: center;
}
</style>
<title id="pageTitle">Collection</title>
</head>
<body style="margin:10px">

	<script type="text/javascript">
		$(document).ready(function() {		
			$('input:file').change(function() {
				if ($(this).val()) {
					$('#fileSub').attr('disabled', false);
					// or, as has been pointed out elsewhere:
					// $('input:submit').removeAttr('disabled'); 
				}
			});
			$("#txtArea").on("input propertychange", function() {
				if ($("#txtArea").val().trim().length < 1) {
					$('#txtSub').attr('disabled', true);
				} else {
					$('#txtSub').attr('disabled', false);
				}
			}

			)
			$('#txtArea').each(function () {
				  this.setAttribute('style', 'height:' + (this.scrollHeight) + 
						  'px;overflow-y:hidden;margin:auto;');
				}).on('input', function () {
				  this.style.height = 'auto';
				  this.style.height = (this.scrollHeight) + 'px';
				});
		});
	</script>
<style>
#fileIn{
    display: none;
}
div.show-image {
    position: relative;
    float:left;
    margin:5px;}

div.show-image:hover input
  {
  display: block;
  }

div.show-image input {
    position:absolute;
    top:0;
    left:0;
    display:none;
}
+</style>
	
	<%
		ObjectifyService.register(Profile.class);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		String collectionName = request.getParameter("collection");
		String username = request.getParameter("username");
		pageContext.setAttribute("username", username);
		pageContext.setAttribute("collection", collectionName);
		//ObjectifyService.ofy().clear();

		Profile profile = ObjectifyService.ofy().load().type(Profile.class).filter("username", username).first().now();
		/*
		System.out.println("Desired profile: " + username);
		if (username != null && username.length() > 0) {
			//pull up desired one
			profile = ObjectifyService.ofy().load().type(Profile.class).filter("username", username).first().now();
		} 
		
		else {
			//pull up your own 
			profile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		}
		*/
		//ObjectifyService.ofy().clear();
		Profile myProfile = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", user).first().now();
		if (myProfile.equals(profile)) {
	%>
	<nav class="navbar navbar-default">
		<div class="container-fluid">
			<a class="navbar-brand navbar-header" href="welcomePage.jsp" style=>Collection Connection</a>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="profilePage.jsp?username=<%=myProfile.getUsername()%>">My Profile</a></li>
				<li><a role="button" href="<%=userService.createLogoutURL("/welcomePage.jsp")%>">
					<span class="glyphicon glyphicon-log-out"></span>
					Sign Out</a>
				</li>
			</ul>
		</div>
	</nav>
	<form action="<%=blobstoreService.createUploadUrl("/upload")%>"
		method="post" enctype="multipart/form-data">
		<label class="btn btn-default">
			<input type="file" id="fileIn" name="myFile" accept="image/*"
				onchange="javascript:this.form.submit();">
			File Upload
		</label>
		<input type="hidden" name="collectionName" value="${fn:escapeXml(collection)}" />
	</form>

	<%
		}
		if (profile != null) {
			Collection collection = profile.findCollection(collectionName);
			if (collection != null) {
				pageContext.setAttribute("collection", collection.getCollectionName());
	%>
		<h1>${fn:escapeXml(collection)}</h1>
		<div class="container text-center">
		<div class="row">
		<h1 align="center">${fn:escapeXml(collection)}</h1>
		<%
			ArrayList<Photo> photos = collection.getPhotos();
					for (Photo photo : photos) {
						pageContext.setAttribute("blobkey", photo.getBlobKey());
						pageContext.setAttribute("photoname", photo.getName());
		%>
			<div class="col-sm-4">
			<a href = "serve?blob-key=${fn:escapeXml(blobkey)}" data-lightbox="${fn:escapeXml(collection)}">
			<div class="show-image">
				<img width="250" height="150" title="${fn:escapeXml(photoname)}"
									src="serve?blob-key=${fn:escapeXml(blobkey)}">
				<form action ="/delete" method = "post">
				<input class="the-buttons" type="button" value="X" />
				</form>
			</div>
			</a>
			 
			</div>
		<img width="200" height="150" title="${fn:escapeXml(photoname)}"
			src="serve?blob-key=${fn:escapeXml(blobkey)}">
		<%
			}
					%>
					</div>
					</div>
		<% 

			pageContext.setAttribute("username", profile.getUsername());
					pageContext.setAttribute("username", profile.getUsername());
		%>
		<br><br><br>
		<h2>Comments</h2>
		<h2 align="center">Comments</h2>
		<form class="center" style="margin:auto;margin-bottom:53px" action="/comment" method="post">
			<textarea name="comment" id="txtArea" class="form-control form-horizontal" placeholder="Comment here..." rows="1"></textarea>
			<input type="submit"  id="txtSub"  value="Post comment" style="margin-top:10px;float:right" class="btn btn-success"   disabled>
			<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
			<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
		</form>
		
		<%
			//pull up comments for this profile and this collection
					ArrayList<Comment> comments = collection.getComments();

					for (Comment comment : comments) {
						//ObjectifyService.ofy().clear();
						Profile profileOfComment = ObjectifyService.ofy().load().type(Profile.class).filter("actualUser", comment.getUser()).first().now();

						pageContext.setAttribute("comment", comment.getComment());
						pageContext.setAttribute("usernameOfComment", profileOfComment.getUsername());
		%>
				<p id="commentTest"><b>${fn:escapeXml(usernameOfComment)}: </b>${fn:escapeXml(comment)}</p>
		<%
			}
				}
		%>
	<br>
	<form action="/comment" method="post">
			<textarea name="comment" class = "form-control" id="txtArea" placeholder="Comment here..." rows="1" cols="30"></textarea>
			<input style="margin-top:10px" class="btn btn-success" id="txtSub" type="submit" value="Post comment" disabled>
			<input type="hidden" name="username" value="${fn:escapeXml(username)}" />
			<input type="hidden" name="collection" value="${fn:escapeXml(collection)}" />
	</form>
	<%
		}
	%>
	<!-- <a href="profilePage.jsp?username=${fn:escapeXml(username)}" role="button">Back to My Profile</a> -->
</body>
</html>