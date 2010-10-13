<%
Function BuildUpload(RequestBin)
	Response.Buffer = True
	Response.Clear()
	'Get the boundary
	PosBeg      = 1
	PosEnd      = InstrB(PosBeg, RequestBin, getByteString(chr(13)))
	boundary    = MidB(RequestBin, PosBeg, PosEnd - PosBeg)
	boundaryPos = InstrB(1, RequestBin, boundary)

	'Get all data inside the boundaries
	Do until (boundaryPos = InstrB(RequestBin, boundary & getByteString("--")))

	'Members variable of objects are put in a dictionary object
	Dim UploadControl
	Set UploadControl = CreateObject("Scripting.Dictionary")

	'Get an object name
	Pos      = InstrB(BoundaryPos, RequestBin, getByteString("Content-Disposition"))
	Pos      = InstrB(Pos, RequestBin, getByteString("name="))
	PosBeg   = Pos + 6
	PosEnd   = InstrB(PosBeg, RequestBin, getByteString(chr(34)))
	Name     = getString(MidB(RequestBin, PosBeg, PosEnd - PosBeg))
	PosFile  = InstrB(BoundaryPos, RequestBin, getByteString("filename="))
	PosBound = InstrB(PosEnd, RequestBin, boundary)

	'Test if object is of file type
	If PosFile <> 0 AND (PosFile < PosBound) Then
		'Get Filename, content-type and content of file
		PosBeg   = PosFile + 10
		PosEnd   = InstrB(PosBeg, RequestBin, getByteString(chr(34)))
		FileName = getString(MidB(RequestBin, PosBeg, PosEnd - PosBeg))

		'Add filename to dictionary object
		UploadControl.Add "FileName", FileName
		Pos    = InstrB(PosEnd, RequestBin, getByteString("Content-Type:"))
		PosBeg = Pos + 14
		PosEnd = InstrB(PosBeg, RequestBin, getByteString(chr(13)))

		'Add content-type to dictionary object
		ContentType = getString(MidB(RequestBin, PosBeg, PosEnd - PosBeg))
		UploadControl.Add "ContentType", ContentType

		'Get content of object
		PosBeg = PosEnd + 4
		PosEnd = InstrB(PosBeg, RequestBin, boundary) - 2
		Value  = MidB(RequestBin, PosBeg, PosEnd - PosBeg)
	Else
		'Get content of object
		Pos    = InstrB(Pos, RequestBin, getByteString(chr(13)))
		PosBeg = Pos + 4
		PosEnd = InstrB(PosBeg, RequestBin, boundary) - 2
		Value  = getString(MidB(RequestBin, PosBeg, PosEnd - PosBeg))
	End If

	UploadControl.Add "Value" , Value
	ClientRequest.Add name, UploadControl
	BoundaryPos = InstrB(BoundaryPos + LenB(boundary), RequestBin, boundary)
	Loop
End Function

Function getByteString(StringStr)
	For i = 1 to Len(StringStr)
		char = Mid(StringStr, i, 1)
		getByteString = getByteString & chrB(AscB(char))
	Next
End Function

Function getString(StringBin)
	getString = ""
	For intCount = 1 to LenB(StringBin)
		getString = getString & chr(AscB(MidB(StringBin, intCount, 1)))
	Next
End Function

Function ShowError(msg)
	Set Conn = Nothing
	Set ClientRequest = Nothing
	Response.Redirect(Application("site_url") & "/default.asp?error=" & msg)
End Function

Function do_delete(filename)
	Dim fs
	Set fs = Server.CreateObject("Scripting.FileSystemObject") 
	If fs.FileExists(Application("upload_path") & "/" & filename) Then
		fs.DeleteFile(Application("upload_path") & "/" & filename)
		UploadError(4)
	Else
		UploadError(5)
	End If
	Set fs = nothing
End Function

Function safe_query(s)
	s = Replace(s, "'", "&#39;") 
	's = Replace(s, "", "&quote;") 
	safe_query = s
End Function

Function SaveFiles
    Dim Upload, fileName, fileSize, ks, i, fileKey

    Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)

	' If something fails inside the script, but the exception is handled
	If Err.Number<>0 then Exit function

    SaveFiles = ""
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
        SaveFiles = "<B>Files uploaded:</B> "
        for each fileKey in Upload.UploadedFiles.keys
            SaveFiles = Upload.UploadedFiles(fileKey).FileName
        next
    else
        'SaveFiles = "The file name specified in the upload form does not correspond to a valid file in the system."
    end if
End function
%>