<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="include/freeASPUpload.asp" -->

<%
Server.ScriptTimeout = 36000


Dim MyUploader, File, idx, Conn

	
Set Conn = CreateObject("ADODB.Connection")
Conn.Open Application("conn_str")

Set MyUploader = New FreeASPUpload
MyUploader.Save(Application.Contents("upload_path") & "/")

Dim c_channel, c_title, c_desc, c_private, c_uid
c_channel = CInt(MyUploader.Form("channel_id"))

c_title = Replace(MyUploader.Form("title"), "'", "&#39;")
'c_title = Replace(MyUploader.Form("title"), "", "&quot;")

c_desc = Replace(MyUploader.Form("desription"), "'", "&#39;")
'c_desc = Replace(MyUploader.Form("desription"), "", "&quot;")
c_uid = CInt(MyUploader.Form("uid"))

if IsEmpty(MyUploader.Form("private")) then
	c_private =  MyUploader.Form("private")
end if

ks = MyUploader.UploadedFiles.keys

path = MyUploader.Form("clipname")
image = MyUploader.Form("imagename")
dim name_clip, name_image
name_clip =  CLng(DateDiff("s", "01/01/1970 00:00:00", Now)) & path
name_image =  CLng(DateDiff("s", "01/01/1970 00:00:00", Now)) & image

dim fs
set fs=Server.CreateObject("Scripting.FileSystemObject")
fs.MoveFile Application.Contents("upload_path") & "/" & path, Application.Contents("upload_path") & "/" & name_clip
fs.MoveFile Application.Contents("upload_path") & "/" & image, Application.Contents("upload_path") & "/" & name_image
set fs=nothing


query = "INSERT INTO mc_clips (title,description,chanel_id, path, image, private, date_added, [submiter], last_modified) VALUES('" & c_title & "','" & c_desc & "','" & c_channel & "','" & name_clip & "','" & name_image & "','" & c_private & "','" & Date & "','" & c_uid & "','" & Date &"')"
		
'Response.Write(query)
Conn.Execute query
Conn.Execute "update mc_channel set total_clips=total_clips+1 where cid="&c_channel

Response.Redirect(Application("site_url") & "/redirect.asp?id=20&url=%3Fact%3Dupload")

%>
