<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="include/class.upload.asp" -->
<%
Server.ScriptTimeout = 3600

Response.Buffer = True
Response.Clear()
If(Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	
	Dim Conn,Rs,ClientRequest
	
	Set Conn = CreateObject("ADODB.Connection")
	Conn.Open Application("conn_str")
	
	Set ClientRequest = CreateObject("Scripting.Dictionary")
	BuildUpload(Request.BinaryRead(Request.TotalBytes))

	Dim c_channel, c_title, c_desc, c_private
	c_channel = CInt(ClientRequest.Item("channel_id").Item("Value"))
	c_title = ClientRequest.Item("title").Item("Value")
	c_desc = ClientRequest.Item("desription").Item("Value")
	c_private = 0
	
	'handle upload clip
	If ClientRequest.Item("clippath").Item("FileName") <> "" Then
		Response.Buffer = True
		Response.Clear()
		Dim vFileName, vFileType, vFileBin, vOutFileName, vOutFilePath
			
		vFileName     = LCase(ClientRequest.Item("clippath").Item("FileName"))
		vFileType     = Replace(vFileName, Left(vFileName, InstrRev(vFileName, ".")), "")
		vFileBin      = ClientRequest.Item("clippath").Item("Value")
		vOutFileName  = "clip_" & CLng(DateDiff("s", "01/01/1970 00:00:00", Now)) & "." & vFileType
		vOutFilePath  = Application.Contents("upload_path") & "/" & vOutFileName
		
		If InStr(1, Application("clip_ext"), vFileType, vbTextCompare) < 1 Then
			ShowError(17)
		End If
		
		If LenB(vFileBin) > (Application("clip_size_mb")) Then
			ShowError(18)
		End If
				
		Dim voFSO, voIMG
		Set voFSO = CreateObject("Scripting.FileSystemObject")
		Set voIMG = voFSO.CreateTextFile(vOutFilePath, true)
		
		
		Dim vi, vl
		For vi = 1 To LenB(vFileBin)
			On Error Resume Next
			vl = AscB(MidB(vFileBin, vi, 1))
			voIMG.Write Chr(vl)
			If Err.Number <> 0 Then Err.Clear
		Next
		
		voIMG.Close
		Set voIMG = Nothing
		Set voFSO = Nothing		
		path = vOutFileName
	End If
	
	'handle upload image	
	If ClientRequest.Item("image").Item("FileName") <> "" Then
		Response.Buffer = True
		Response.Clear()
		Dim FileName, FileType, FileBin, OutFileName, OutFilePath
			
		FileName     = LCase(ClientRequest.Item("image").Item("FileName"))
		FileType     = Replace(FileName, Left(FileName, InstrRev(FileName, ".")), "")
		FileBin      = ClientRequest.Item("image").Item("Value")
		OutFileName  = "image_" & CLng(DateDiff("s", "01/01/1970 00:00:00", Now)) & "." & FileType
		OutFilePath  = Application.Contents("upload_path") & "/" & OutFileName
			
		If InStr(1, Application("image_ext"), FileType, vbTextCompare) < 1 Then
			ShowError(17)
		End If
		
		If LenB(FileBin) > (Application("image_ext_kb")*1024) Then
			ShowError(18)
		End If
				
		Dim oFSO, oIMG
		Set oFSO = CreateObject("Scripting.FileSystemObject")
		Set oIMG = oFSO.CreateTextFile(OutFilePath, true)
		
		
		Dim i, l
		For i = 1 To LenB(FileBin)
			On Error Resume Next
			l = AscB(MidB(FileBin, i, 1))
			oIMG.Write Chr(l)
			If Err.Number <> 0 Then Err.Clear
		Next
		
		oIMG.Close
		Set oIMG = Nothing
		Set oFSO = Nothing
		image = OutFileName
	End If
	
	
		query = "INSERT INTO mc_clips (title,description,channel_id, path, image, private, date_added) VALUES('" & safe_query(c_title) & "'," & safe_query(c_desc) & ",'" & intval(c_channel) & "','" & path & "','" & image & "','" & c_private & "','" & date &"')"
		
		Response.Write(query)
		
		Conn.Close		
				
		Set ClientRequest = Nothing
		Set Conn = Nothing
		//Response.Redirect(Application("site_url") & "/redirect.asp?id=20&url=%3Fact%3Dupload")

Else
	Response.Redirect(Application("site_url") & "/admin/player%2Easp")
End IF
%>