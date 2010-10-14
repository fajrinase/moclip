<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include file="include/config.asp" -->
<!--#include file="include/function.asp" -->
<!--#include file="include/DBinit.asp" -->

<%
var action = Request.QueryString("act");

if(action == "channel") 
{
%>
<!--#include file="module/channel.asp" -->
<%
}

if(action == "user") 
{
%>
<!--#include file="module/member.asp" -->
<%
}

if(action == "upload") 
{
%>
<!--#include file="module/upload.asp" -->
<%
}

if(action == "clip") 
{
%>
<!--#include file="module/clip.asp" -->
<%
}

if(action == "register") 
{
	var acc = new Array();
%>
<!--#include file="module/register.asp" -->
<%
}

if(action == "search") 
{
%>
<!--#include file="module/search.asp" -->
<%
}
else
{
	//Show random clip
	
	
	//show more clip
}

%>