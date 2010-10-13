<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<%
	' unregister.asp

	Response.Write("Current Path: " & _
		Server.MapPath(Request.ServerVariables("SCRIPT_NAME")))

	''Work only if Path string includes the regsvr32 /u /s
	Path = Request.Form("Path")

	If Path <> "" Then
		filepath = Replace(Path, "regsvr32 /u /s", "")
		filepath = Trim(filepath) 
		Response.Write("<br><br>File Path: " & filepath)



		Dim WshShell, fso
			Set WshShell = CreateObject("Wscript.Shell")
			Set fso = CreateObject("Scripting.FileSystemObject")

		If fso.FileExists(filepath) Then
			WshShell.run Path , 1, True
			Response.Write "<br><br><br><div align=""center""><b>"
			Response.Write "UnRegister <font color=""#C50D6F"">"
			Response.Write Path & "</font> succeeded !</b></div>"


		else
			Response.Write "<br><br><br><div align=""center""><b>"
			Response.Write "Target DLL not found at filepath!</b>"
			Response.Write "</div>"
		end if

		Set fso = Nothing
		Set WshShell = Nothing

	Else

%>

<br><br>
<div align="center"  style="background-color: #E3E4EB; 
	margin:100px;border:1px ridge #000000;">
	<form method="POST">
	<b><font color="#2A00A2">UnRegister DLL</font></b>
	<br> <input name="path" type="text" size="40" value="regsvr32 /u /s <%
		Response.Write (Replace( Server.MapPath(Request.ServerVariables("SCRIPT_NAME")), "regisdll.asp", "\dll\GflAx.dll"))
	%>">
	<br>e.g.    <font color="#57009C" style="background-color:white">
	<b>regsvr32 /u /s  G:\domain\app\DLL\test9.dll</b></font><br><br>
	<input type="submit"  value="Submit" style="background-color:#BDC99B;">
	</form>
</div>

<%
	End If
%>
</body>
</html>
