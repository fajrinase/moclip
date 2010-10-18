<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include file="include/function.asp" -->
<!--#include file="include/config.asp" -->
<!--#include file="include/DBinit.asp" -->


<%
var txt 	= new Array();
var msg  	= "";
var url  	= config["site_url"] + "/default.asp";

txt[0]  = "Added Comment Successfully!";
txt[1]	= "Your Search Keyword is too short!";

//Account
txt[10] = "Register Success. Please try to login."
txt[11] = "You are login successfull";
txt[12] = "You are logout now";

//upload
txt[20] = "Your Clip was uploaded Success. It must be approved before other people can watch it."

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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-gb" lang="en-gb">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="robots" content="index, follow" />
<meta name="keywords" content="" />
<meta name="description" content="MoClip!" />
<meta name="generator" content="" />
<meta http-equiv="refresh" content="2; url=<%=url%>" />
<title>MoClip!</title>
<link rel="stylesheet" href="public/css/template.css" type="text/css" />
</head>
<body id="bd">

  
  <div class="borderwrap">
  	<div class="maintitle">Thanks !</div>
   	<div class="maintitle" style="margin:1px;color:#c4c4cc;">Redirecting...</div>
   	<div class="row2" style="padding:5px;"><%=msg%></div>
	  <div class="row2"><br />
		  <div align="center"><img src="<%=config["image_url"]%>/loading.gif" alt="" /></div>
		  <div align="center" style="padding:3px;"><a href="<%=url%>"><i>( Click here if you do not wish to wait... )</i></a></div>
		</div>
 	</div>
  </div>
</body>
</html>