<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="include/upload.asp" -->

<%
Dim MyUploader, File, idx, Conn

	
Set Conn = CreateObject("ADODB.Connection")
Conn.Open Application("conn_str")

Set MyUploader = New FileUploader

MyUploader.Upload()


Dim c_channel, c_title, c_desc, c_private, c_uid
c_channel = CInt(MyUploader.Form("channel_id"))

c_title = Replace(MyUploader.Form("title"), "'", "&#39;")
'c_title = Replace(MyUploader.Form("title"), "", "&quot;")

c_desc = Replace(MyUploader.Form("desription"), "'", "&#39;")
'c_desc = Replace(MyUploader.Form("desription"), "", "&quot;")
c_uid = CInt(MyUploader.Form("uid"))

if IsEmpty(MyUploader.Form("private")) then
	c_private =  MyUploader.Form("desription")
end if


idx = 0

For Each File In MyUploader.Files.Items
	'save to disk
	File.FileName = CLng(DateDiff("s", "01/01/1970 00:00:00", Now)) &  File.FileName
	if idx = 0 then
		path = File.FileName
	else
		image = File.FileName
	end if
	
	'File.SaveToDisk  Application.Contents("upload_path") & "/"
	idx = idx + 1
Next


query = "INSERT INTO mc_clips (title,description,chanel_id, path, image, private, date_added, [submiter], last_modified) VALUES('" & c_title & "','" & c_desc & "','" & c_channel & "','" & path & "','" & image & "','" & c_private & "','" & Date & "','" & c_uid & "','" & Date &"')"
		
'Response.Write(query)

Conn.Execute query

Response.Redirect(Application("site_url") & "/redirect.asp?id=20&url=%3Fact%3Dupload")

%>
