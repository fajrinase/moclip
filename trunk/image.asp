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
'	.ChangeColorDepth 256
	.SaveformatName = "jpeg"
	.SaveJPEGProgressive = True 'Progressive
    .SaveJPEGQuality = 70 'Quality of 70%
	newWidth = nWidth 'Get the height according to the width (keep the ratio)
    newHeight = nWidth / 1.85'(newWidth * .Height) / (.Width) 
    
    .Resize newWidth, newHeight 'Resize the pciture
	'.ResizeCanvas newWidth, newHeight, RGB(0,0,0)

	'.FontName = "arial"
	'.FontSize = 13
	'.TextOut "MoClip!", 5, 5, RGB(255, 255, 255) 'Write library version on the picture

	response.contenttype = "image/jpeg"
	response.binarywrite .SendBinary
end with

set ctrl=nothing
%>
