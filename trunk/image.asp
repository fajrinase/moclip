<%
'   Use a ASP file as source of a <IMG> tag to display a picture in a HTML page
'   add a text.

'   The following contenttype are available :
'   response.contenttype = "image/jpeg"
'   response.contenttype = "image/gif"
'	response.contenttype = "image/png"
'	response.contenttype = "image/bmp"
'	response.contenttype = "image/tiff"
'	response.contenttype = "image/xpm"

Dim Path, iFilename, File, nWidth, nHeight

Set ctrl = server.createobject("GflAx.GflAx")
iFilename = request.QueryString("f")
nWidth = request.QueryString("w")
nHeight = request.QueryString("h")
Path = Server.MapPath("uploads") 

File = Path & "\" & iFilename

With ctrl
	.enablelzw= True
	.LoadBitmap File
	.SaveformatName = "jpeg"
	newWidth = nWidth 'Get the height according to the width (keep the ratio)
    newHeight = (newWidth * .Height) / .Width
    
    .Resize newWidth, newHeight 'Resize the pciture

	.FontName = "arial"
	.FontSize = 13
	'.TextOut "GflAx 200 - Exemple 1", 5, 5, RGB(255, 255, 255) 'Write library version on the picture

	response.contenttype = "image/png"
	response.binarywrite .SendBinary
end with

set ctrl=nothing
%>
