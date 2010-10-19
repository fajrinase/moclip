<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include file="include/function.asp" -->

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-gb" lang="en-gb">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="robots" content="index, follow" />
<meta name="keywords" content="" />
<meta name="description" content="MoClip!" />
<meta name="generator" content="" />

<title>MoClip! Installer</title>

<link rel="stylesheet" href="public/css/template.css" type="text/css" />
<style>
.maintitle {
	color : #FF6F00;
	font-weight: bold;
	border-bottom:3px solid #CCCCCC;
}
</style>
</head>
<body id="bd"> 
 <div class="borderwrap">
  	<div class="maintitle">MoClip! Installer</div>
   	<div>
		<table>
<%
if( trim(Request.Form("user")) != "" && trim(Request.Form("password")) != "" )
{
	
	
	Application.Lock();	
	Session.CodePage = 65001;
	
	
	Application.Contents("conn_str") = "Provider="+trim(Request.Form("dbtype"))+"; Data Source="+trim(Request.Form("path"))+"; Initial Catalog="+trim(Request.Form("db"))+"; User ID="+trim(Request.Form("user"))+"; Password="+trim(Request.Form("password"))+";"	
	Application.UnLock();
	var conn = Server.CreateObject("ADODB.Connection");
	conn.Open(Application("conn_str"))
	
	//get DB file
	var path = Server.MapPath("DB");
	
	//Response.Write(path+"\\dbscript.sql");
	
	var fs = Server.CreateObject("Scripting.FileSystemObject")
	//var f = fs.GetFile(path+"\\dbscript.sql");
	var f = fs.OpenTextFile(path+"\\droptable.txt", 1)
	if( ! f.AtEndOfStream ) {
		txt = f.ReadAll();
	}
	
	//Drop everything if exist
	Response.Write("Drop Table....");
	//conn.Execute(txt);
	Response.Write("Done");
	
	//Install table, data, structure
	f = fs.OpenTextFile(path+"\\dbscript.sql", 1)
	if( ! f.AtEndOfStream ) {
		txt = f.ReadAll();
	}
	
	Response.Write("<br/>Install Database....");
	//conn.Execute(txt);
	
	Response.Write("Done");
	
	//Install store
	Response.Write("<BR />Install Store....");
	f = fs.OpenTextFile(path+"\\s_procedure\\sp_updatechannel.txt", 1)
	if( ! f.AtEndOfStream ) {
		txt = f.ReadAll();
	}
	
	//conn.Execute(txt);
	
	f = fs.OpenTextFile(path+"\\s_procedure\\sp_removechannel.txt", 1)
	if( ! f.AtEndOfStream ) {
		txt = f.ReadAll();
	}
	
	//conn.Execute(txt);
	
	f = fs.OpenTextFile(path+"\\s_procedure\\sp_removeclip.txt", 1)
	if( ! f.AtEndOfStream ) {
		txt = f.ReadAll();
	}
	
	//conn.Execute(txt);	
	
	conn.Close();
	Response.Write("Done");
	
	
	//Create config file
	Response.Write("<BR />Create config file....");
	path = Server.MapPath("include");
	fo=fs.GetFolder(path);
	tfile=fo.CreateTextFile("db.xml",true, true);
	tfile.WriteLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	tfile.WriteLine("<config>");
	
	tfile.WriteLine("<sql_provider>"+trim(Request.Form("dbtype"))+"</sql_provider>");
	tfile.WriteLine("<sql_datasource>"+trim(Request.Form("path"))+"</sql_datasource>");
	tfile.WriteLine("<sql_catalog>"+trim(Request.Form("db"))+"</sql_catalog>");
	tfile.WriteLine("<sql_userid>"+trim(Request.Form("user"))+"</sql_userid>");
	tfile.WriteLine("<sql_password>"+trim(Request.Form("password"))+"</sql_password>");
	tfile.WriteLine("<db_name>"+trim(Request.Form("db"))+"</db_name>");	
	tfile.WriteLine("</config>");
	Response.Write("Done");
	
}
else
{
%>

 
		<form method="post">
		<tr>
			<td>Selecte Database</td>
			<td>
				<select name="dbtype">
					<option value="SQLNCLI10">MSSQL 2008</option>
					<option value="SQLOLEDB.1">MSSQL 2005</option>
				</select>
			</td>
		</tr>
		<tr>
			<td>Database Address</td>
			<td>
				<input type="text" name="path" value="(local)"/>
			</td>
		</tr>
		<tr>
			<td>Database user</td>
			<td>
				<input type="text" name="user" value=""/>
			</td>
		</tr>
		<tr>
			<td>Database password</td>
			<td>
				<input type="password" name="password" value=""/>
			</td>
		</tr>
		<tr>
			<td>Database name</td>
			<td>
				<input type="text" name="db" value=""/>
			</td>
		</tr>
				
		<tr>
			<td colspan="2" align="center"> 
				<input type="submit" class="shareit" value="Install" />
				<input type="reset" class="shareit" value="Cancel" />
			</td>
		</tr>
		</form>
		
<%
}
%>
		</table>
	</div>
 	</div>
  </div>
</body>
</html>
