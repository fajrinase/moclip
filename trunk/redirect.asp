<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include file="include/function.asp" -->
<!--#include file="include/config.asp" -->
<!--#include file="include/DBinit.asp" -->

<!-- #include file="public/header.asp" -->
<%
var txt 	= new Array();
var msg  	= "";
var url  	= config["site_url"] + "/default.asp";

txt[0]  = "Added Comment Successfully!";
txt[1]	= "Your Search Keyword is too short!";

//Account
txt[10] = "Register Success. Please try to login."

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
	url = config["site_url"] + "/" + Request.QueryString("url");
}
else if(Request.ServerVariables("HTTP_REFERER") != "")
{
	url = Request.ServerVariables("HTTP_REFERER");
}
%>
  <meta http-equiv="refresh" content="5; url=<%=url%>" />
  <h1 style="background:#919193;border:#222 1px solid">Thanks !</h1>
  <div style="background:#ACACAE;border:#222 1px solid;border-top:0">
   <div style="margin:1px;color:#ffffff;">Redirecting...</div>
   <div class="row2" style="padding:5px;"><%=msg%></div>
	  <div class="row2"><br />
		  <div align="center"><img src="<%=config["image_url"]%>/loading.gif" alt="" /></div>
		  <div align="center" style="padding:3px;"><a href="<%=url%>"><i>( Click here if you do not wish to wait... )</i></a></div>
		</div>
 	</div>
<!-- #include file="public/footer.asp" -->