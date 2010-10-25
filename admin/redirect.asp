<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual ="moclip/include/config.asp" -->
<!--#include virtual ="moclip/include/function.asp" -->
<!--#include file="public/header.asp"-->
<%
var txt 	= new Array();
var msg  	= "";
var url  	= config["site_url"] + "/admin/admin.asp";

// Login
txt[1]  = "Login Successfully!";
txt[2]  = "Logout Successfully!";

//Channel
txt[5] = "Channel added Successfully!";
txt[6] = "Channel delete Successfully!";
txt[7] = "Channel update Successfully!";
txt[8] = "Channel Sync Successfully!";

//Comments
txt[10] = "Comment has been deleted";
txt[11] = "Comment has been approved";
txt[12] = "Comment has been unapproved";


// Admin User
txt[15] = "Admin User Added Successfully!";
txt[16] = "Admin User deleted Successfully!";

//Clip
txt[20] = "Clip has been deleted Successfully!";
txt[21] = "Clip has been approved Successfully!";
txt[22] = "Clip has been denied Successfully!";
txt[23] = "Clip has been updated Successfully!";
txt[25] = "Clip has been resolved!";

//News
txt[30] = "News has been added!";
txt[31] = "News has been deleted!";

if(isset(txt[Request.QueryString("id")]))
{
	msg = txt[Request.QueryString("id")];
}
else
{
	msg = "Please wait while we transfer you...";
}

if(isset(Request.QueryString("url")) && Request.QueryString("url") != "")
{
	url = config["site_url"] + "/admin/" + Request.QueryString("url");
}
else if(Request.ServerVariables("HTTP_REFERER") != "")
{
	url = Request.ServerVariables("HTTP_REFERER");
}
%>
  <meta http-equiv="refresh" content="1; url=<%=url%>" />
  
  <div class="borderwrap">
  	<div class="maintitle">Thanks !</div>
   	<div class="maintitle" style="margin:1px;color:#ffffff;">Redirecting...</div>
   	<div class="row2" style="padding:5px;"><%=msg%></div>
	  <div class="row2"><br />
		  <div align="center"><img src="<%=config["image_url"]%>/loading.gif" alt="" /></div>
		  <div align="center" style="padding:3px;"><a href="<%=url%>"><i>( Click here if you do not wish to wait... )</i></a></div>
		</div>
 	</div>
</div>
</body>
</html>