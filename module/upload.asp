<%

if(user["id"] > 0)
{
	
%>
<form name="uploadClip" method="POST" enctype="multipart/form-data" action="addclip.asp">
<input type="hidden" name="uid" value="<%=user["id"]%>" />
	<table width="100%">
		<tr>
			<td width="60%">
				<table width="100%">
					<caption style="text-align:left; font-size: 20px; font-weight: bold;">Clip Upload File</caption>
					
					<tr>
						<td>
							<label for="channel">Channel<span style="color:#FF0000 !important">*</span></label>
						</td>
						<td>
							<select name="channel_id" id="channel">
							<option value='0' selected="selected" style="color:#FFFF99">Please select a Channel</option>
							<% 
								rs = Server.CreateObject("ADODB.Recordset");
								rs.Open("SELECT cid, title  FROM mc_channel ORDER BY title ASC", conn);
								
								while(! rs.EOF)
								{
									Response.Write("<option value='"+rs("cid")+"'>"+rs("title")+"</option>" );
									rs.MoveNext;
								}
								
								rs.Close();
								rs = null;	
							
							%>
							</select>
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="title">Title<span style="color:#FF0000 !important">*</span></label>
						</td>
						<td>
							<input id="title" type="text"  name="title" value="" />
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="desc">Desription</label>
						</td>
						<td>
							<textarea id="desc" name="desription" ></textarea>
						</td>
					</tr>
					
					<tr>
						<td>
							Clip File<span style="color:#FF0000 !important">*</span>
						</td>
						<td>
							<input type="text" name="clipname"  value="" class="file" id="clipFile" readonly />
						
							<div class="file_input_div">
							  <input type="button" value="Search Clip" class="file_input_button" />
							  <input name="clippath" type="file" class="file_input_hidden" onchange="return selectClip(this)" />
							</div>
						</td>
					</tr>
										
					<tr>
						<td>
							Cover Image<span style="color:#FF0000 !important">*</span>
						</td>
						<td>
							<input type="text" name="imagename" value="" class="file" id="clipImage" readonly />
							<div class="file_input_div">
							  <input type="button" value="Search Image" class="file_input_button" />
							  <input name="image"  type="file" class="file_input_hidden" onchange="return selectImage(this)" />
							</div>
						</td>
					</tr>
					
					
					
					<tr>
						<td>
							<label for="private">Private Use?</label>
						</td>
						<td>
							<input id="private" type="checkbox" name="private"  value="1" class="" />
						
						</td>
					</tr>
					
					<tr>
						<td colspan="2" align="center">
							<input type="reset"  name="reset" value="Reset" />
							<input type="submit" class="shareit"  name="submit" value="Share Clip!" onclick="return submitShareForm()"/>
						</td>
					</tr>
				</table>
			</td>
			<td width="40%" valign="top">
				<div style="margin-top: 25px;">Videos can be...</div>
				<ul style="list-style-type:circle; margin-top: 5px;">
					<li>High Definition</li>
					<li>Up to <% Response.Write(config["clip_size_mb"]) %> MB in size.</li>
					<li>Up to 15 minutes in length.</li>
					<li>Currently support FLV and MP4 video format.</li>
				</ul>
			</td>
		</tr>
	</table>
</form>
<div style="margin-top: 150px; font-size: 11px;">


<b>Important</b>: Do not upload any TV shows, music videos, music concerts, or commercials without permission unless they consist entirely of content you created yourself.
<br />
The Copyright Tips page and the Community Guidelines can help you determine whether your video infringes someone else's copyright.
<br />
By clicking "Share Clip", you are representing that this video does not violate Our's Terms of Use and that you own all copyrights in this video or have authorization to upload it.


</div>

<script type="text/javascript">
var formError = 0;

selectImage = function(obj) {
	var ext = getFileExtension(obj.value);

	if(ext == "jpg" || ext == "gif" || ext == "png") {
		document.getElementById('clipImage').value = obj.value;
	}
	else
	{
		formError = 1;
		alert("Only allow jpg|gif|png, please select other image file!");
		return false;
	}
}

selectClip = function(obj) {
	var ext = getFileExtension(obj.value);
	if(ext == "flv" || ext == "mp4") {
		document.getElementById('clipFile').value = obj.value;
	}
	else
	{
		formError = 2;
		alert("Only allow flv|mp4, please select other clip file!");
		return false;
	}
}

submitShareForm = function() {
	
	var form = document.uploadClip;
	
	if(form.channel_id.value == 0)
	{
		alert("Please select a channel.");
		form.channel_id.focus();
		return false;
	}
	
	if(form.title.value.length < 4)
	{
		alert("Please enter clip's title, must be longer than 4 characters.");
		form.title.focus();
		return false;
	}
	/*
	if(formError == 1  || form.imagename.value == "") {
		alert("Only allow jpg|gif|png, please select other image file!");
		return false;
	}
	
	if(formError == 2 || form.clipname.value == "") {
		alert("Only allow flv|mp4, please select other clip file!");
		return false;
	}
	*/
	
	return true;
}

</script>

<%	
}
else
{
	Response.Write("You don't have permission to upload file. Please login before do this!");
}
%>