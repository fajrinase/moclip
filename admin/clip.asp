<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual ="moclip/include/config.asp" -->
<!--#include virtual ="moclip/include/function.asp" -->
<!--#include virtual ="moclip/include/DBinit.asp" -->

<!--#include file="public/header.asp"-->
<%
var action =  Request.QueryString("act");
%>
		<div id="header">
            <a href="#" class="logo">MoClip!</a>
            <ul id="top-navigation">
                <li><a href="admin.asp" >Homepage</a></li>
                <li><a href="user.asp">Users</a></li>
                <li><a href="clip.asp" class="active">Clips</a></li>
                <li><a href="channel.asp">Channel</a></li>
                <li><a href="comment.asp">Comments</a></li>
                <li><a href="system.asp">System</a></li>
                <li><a href="suggestion.asp">Suggestion</a></li>
				<li><a href="admin.asp?act=logout">Logout</a></li>
            </ul>
        </div>
		
 		<div id="middle">
			<div id="left-column">
				<h3>Menu</h3>
				<ul class="nav">
					<li><a href="clip.asp">Accepted list</a></li>
					<li><a href="clip.asp?act=waitting">Waitting list</a></li>					
					<li><a href="clip.asp?act=reportlist">Report list</a></li>
				</ul>                
			 </div>
			<div id="center-column">
				<div class="table" style="margin-bottom: 10px;<% Response.Write((action == "view-report" || action == "solve") ? "display: none;" : "display: block;")%>">
				<form method="get">
					<input type="hidden" name="act" value="<%=Request.QueryString("act")%>">
					<table class="listing">
						<tr>
							<th width="7%">Username: <input type="text"  name="username" value="<%=Request.QueryString("username")%>" size="13"></th>						
							<th width="20%">Full name: <input type="text" name="fullname" value="<%=Request.QueryString("fullname")%>" size="14"></th>
							<th width="20%">Clip name:<input type="text" name="clipname" value="<%=Request.QueryString("clipname")%>" size="14"></th>
							<th width="30%">
								in Channel:
								<select name="channel">
									<option value="all" selected="selected">All</option>
								<%
									var srs = Server.CreateObject("ADODB.Recordset");
									srs.Open("SELECT cid, title  FROM mc_channel ORDER BY title ASC", conn);
									
									while(! srs.EOF)
									{
										Response.Write("<option value='"+srs("cid")+"' "+((intval(srs("cid")) == intval(Request.QueryString("channel"))) ? "selected='selected'" : "")+">"+srs("title")+"</option>");
										srs.MoveNext;
									}
									
									srs.Close();
									srs = null;
								%>
								</select>
							</th>
							<th width="13%">
								Show:
								<select name="displace">
									<option value="10" <%=Request.QueryString("displace") == 10 ? "selected='selected'" : ""%>>10</option>
									<option value="20" <%=Request.QueryString("displace") == 20 ? "selected='selected'" : ""%>>20</option>
									<option value="50" <%=Request.QueryString("displace") == 50 ? "selected='selected'": ""%>>50</option>
									<option value="100" <%=Request.QueryString("displace") == 100 ? "selected='selected'" : ""%>>100</option>
								</select>
							</th>
							<th width="10%">
								<input type="submit" value="Filter" />
							</th>
						</tr>
					</table>
				</form>
				</div>
								
				<div class="table">
<%


if( action == "waitting") {
	listAllDenyClips();
}
else if(action == "reportlist") {
	viewReportList();
}
else if(action == "view-report") {
	viewReportDetails();
}


else if(action == "approve") {
	doApprove(0);
}
else if(action == "deny") {
	doUnApprove(0);
}
else if(action == "delete") {
	deleteClip(0);
}
else if(action == "solve") {
	solveReportClip(0);
}
else if(action == "edit") {
	editClipDetails();
}
else if(action == "updateclip") {
	doeditClipDetails();
}
else if(action == "action") {
	var total = Request.Form("clip_id").count();
	if(total > 0) {
		var ids = Request.Form("clip_id");				
		//new get do
		var doo = Request.QueryString("do")
		if(doo == "approve") {
			doApprove(ids);
		}else if(doo == "deny") {
			doUnApprove(ids);
		}else if(doo == "delete") {
			deleteClip(ids);
		}else {
			Response.Write("Cheater!");
		}
	}
}
else {
	listAllApproveClips();
}


function solveReportClip()
{
	var id = intval(Request.QueryString("id"));
	conn.Execute ("delete from mc_report where clip_id="+id);
	redirect(25, "clip.asp?act=reportlist");
}


function listAllApproveClips()
{
	//Build query string
	var current_page		= 1;
	var perpage 			= intval(Request.QueryString("displace")) > 0 ? intval(Request.QueryString("displace")) : 10;
	
	if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
	{
		current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
	}
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.CursorLocation = 3; 
	rs.PageSize       = perpage; 
	rs.CacheSize      = perpage;
	
	var query = "SELECT id,mc_clips.title as clip_title,cast(date_added as date) as clip_date,fullname,username,mc_channel.title as channel_title FROM mc_clips inner join mc_users on(uid=submiter) inner join mc_channel on(cid=chanel_id) where approve=1 ";
	
	var url = "clip.asp?act=list";
	
	if(intval(Request.QueryString("displace")) > 0) {
		url += "displace="+intval(Request.QueryString("displace"));
	}	
	//Build Filter
	//channel
	if(isset(Request.QueryString("channel")) && intval(Request.QueryString("channel")) > 0 )
	{
		query += "and chanel_id="+intval(Request.QueryString("channel"));
		url += "&channel="+intval(Request.QueryString("channel"));
	}
	//Username
	if(isset(Request.QueryString("username")) && Request.QueryString("username") != "Username" )
	{
		query += " and username like '" + safe_query(Request.QueryString("username")) + "%'";
		url += "&username="+Request.QueryString("username");
	}
	//Fullname
	if(isset(Request.QueryString("fullname")) && Request.QueryString("fullname") != "Fullname" )
	{
		query += " and fullname like '"+ safe_query(Request.QueryString("fullname")) + "%'";
		url += "&fullname="+Request.QueryString("fullname");
	}
	//Clipname
	if(isset(Request.QueryString("clipname")) && Request.QueryString("clipname") != "" )
	{
		query += " and mc_clips.title like '"+ safe_query(Request.QueryString("clipname")) + "%'";
		url += "&clipname="+Request.QueryString("clipname");
	}	
	
	query += " order by id DESC";	
	
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, url);
			
	if(total == 0)
	{
		Response.Write("No Clip was displayed");
	}
	else
	{
		var i = 0;
		rs.AbsolutePage = current_page;
		
		%>
		<form method="post" id="clipfrom">
		<table class="listing">	
			<tr>
				<th width="1%"><input type="checkbox" onClick="checkAll(this)" /></th>
				<th width="10%">Username</th>
				<th width="15%">Fullname</th>
				<th width="40%">Clip</th>
				<th width="15%">Channel</th>				
				<th width="10%">On</th>	
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
			</tr>
		<%
	
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{			
			%>
				<tr>
					<td><input type="checkbox" name="clip_id" value="<%=rs("id")%>"/></td>
					<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
					<td style="text-align:left;"><%=(rs("fullname"))%></td>
					<td style="text-align:left;"><a href="../default.asp?act=clip&do=view&id=<%=rs("id")%>" alt="view clip" target="_blank"><%=(rs("clip_title"))%></a></td>
					<td style="text-align:left;"><%=(rs("channel_title"))%></td>
					<td style="text-align:left;"><%=(rs("clip_date"))%></td>					
					<td>
						<a href="clip.asp?act=edit&type=a&id=<%=rs("id")%>"><img src="img/edit-icon.gif" alt="Edit" title="Edit"/></a>						
					</td>
					<td>
						<a href="#" onClick="removeCLip('clip.asp?act=delete&type=a&id=<%=rs("id")%>');"><img src="img/hr.gif" alt="Delete" title="Delete"/></a>
					</td>
					<td>
						<a href="clip.asp?act=deny&type=a&id=<%=rs("id")%>"><img src="img/stop.gif" alt="Deny" title="Deny"/></a>						
					</td>
				</tr>
			<%
			rs.MoveNext;
		}
		%>
			<tr>
				<th colspan="9">
					<input type="button" name="delete" value="Delete" onclick="removeClips()"/>
					<input type="button" name="deny" value="Deny" onclick="denyClips()"/>
				</th>
			</tr>
		<%
			
		Response.Write("</table></form>");
		%>
			<script type="text/javascript">
			var form = document.getElementById("clipfrom");
			function removeCLip(url){
				var a = confirm("Are you sure to delete this clip?");
				if(a) {
					window.location = url;
				}
			}
			function removeClips(){
				var a = confirm("Are you sure want to delete selected clips?");
				if(a) {
					form.action="clip.asp?act=action&type=a&do=delete" ;
					form.submit()
				}
				
			}
			function denyClips() {
				var a = confirm("Are you sure want to deny selected clips?");
				if(a) {
					form.action="clip.asp?act=action&type=a&do=deny";
					form.submit()
				}
			}
			function checkAll(obj) {				
				for(var i = 0; i < form.length; i++) {
					if(form[i].type == "checkbox" && obj.checked == true) {
						form[i].checked = true;
					}
					else {
						form[i].checked = false;
					}
				}			
			}
			</script>
		<%
		if(pageslink != "")
		{
			Response.Write("<div style='text-align:right;margin:5px;'>"+pageslink+"</div>\n");
		}			
	}
	rs.Close();
	rs = null;
}

function listAllDenyClips()
{
	//Build query string
	var current_page		= 1;
	var perpage 			= intval(Request.QueryString("displace")) > 0 ? intval(Request.QueryString("displace")) : 10;
	
	if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
	{
		current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
	}
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.CursorLocation = 3; 
	rs.PageSize       = perpage; 
	rs.CacheSize      = perpage;
	
	var query = "SELECT id,mc_clips.title as clip_title,cast(date_added as date) as clip_date,fullname,username,mc_channel.title as channel_title FROM mc_clips inner join mc_users on(uid=submiter) inner join mc_channel on(cid=chanel_id)  where approve=0 ";
	
	var url= "clip.asp?act=waitting";
	//Build Filter
	//channel
	if(isset(Request.QueryString("channel")) && intval(Request.QueryString("channel")) > 0 )
	{
		query += "and chanel_id="+intval(Request.QueryString("channel"));
		url += "&channel="+intval(Request.QueryString("channel"));
	}
	//Username
	if(isset(Request.QueryString("username")) && Request.QueryString("username") != "" )
	{
		query += " and username like '" + safe_query(Request.QueryString("username")) + "%'";
		url += "&username="+safe_query(Request.QueryString("username"));
	}
	//Fullname
	if(isset(Request.QueryString("fullname")) && Request.QueryString("fullname") != "" )
	{
		query += " and fullname like '"+ safe_query(Request.QueryString("fullname")) + "%'";
		url += "&fullname="+safe_query(Request.QueryString("fullname"));
	}	
	//Clipname
	if(isset(Request.QueryString("clipname")) && Request.QueryString("clipname") != "" )
	{
		query += " and mc_clips.title like '"+ safe_query(Request.QueryString("clipname")) + "%'";
		url += "&clipname="+safe_query(Request.QueryString("clipname"));
	}	
	query += " order by id DESC";	
	
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, url);
			
	if(total == 0)
	{
		Response.Write("No Clip was displayed");
	}
	else
	{
		var i = 0;
		rs.AbsolutePage = current_page;
		
		%>
		<form method="post" id="clipfrom">
		<table class="listing">	
			<tr>
				<th width="1%"><input type="checkbox" onClick="checkAll(this)" /></th>
				<th width="10%">Username</th>
				<th width="15%">Fullname</th>
				<th width="40%">Clip</th>
				<th width="15%">Channel</th>				
				<th width="10%">On</th>	
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
			</tr>
		<%
	
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{			
			%>
				<tr>
					<td><input type="checkbox" name="clip_id" value="<%=rs("id")%>"/></td>
					<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
					<td style="text-align:left;"><%=(rs("fullname"))%></td>
					<td style="text-align:left;"><a href="../default.asp?act=clip&do=view&id=<%=rs("id")%>" alt="view clip" target="_blank"><%=(rs("clip_title"))%></a></td>
					<td style="text-align:left;"><%=(rs("channel_title"))%></td>
					<td style="text-align:left;"><%=(rs("clip_date"))%></td>					
					<td>
						<a href="clip.asp?act=edit&type=b&id=<%=rs("id")%>"><img src="img/edit-icon.gif" alt="Edit" title="Edit"/></a>
					</td>
					<td>
						<a href="#" onClick="removeCLip('clip.asp?act=delete&type=b&id=<%=rs("id")%>');"><img src="img/hr.gif" alt="Delete" title="Delete"/></a>
					</td>
					<td>
						<a href="clip.asp?act=approve&type=b&id=<%=rs("id")%>"><img src="img/add-icon.gif" alt="Approve" title="Approve"/></a>						
					</td>
				</tr>
			<%
			rs.MoveNext;
		}
		
		%>
			<tr>
				<th colspan="9">
					<input type="button" value="Delete" onClick="removeClips()"/>
					<input type="button" value="Approve" onClick="approveClips()"/>
				</th>
			</tr>
		<%
			
		Response.Write("</table></form>");
		%>
			<script type="text/javascript">
			var form = document.getElementById("clipfrom");
			function removeCLip(url)
			{
				var a = confirm("Are you sure to delete this clip?");
				if(a) {
					window.location = url;
				}
			}
			function removeClips(){
				var a = confirm("Are you sure want to delete selected clips?");
				if(a) {
					form.action="clip.asp?act=action&type=a&do=delete" ;
					form.submit()
				}
				
			}
			function approveClips() {
				var a = confirm("Are you sure want to approve selected clips?");
				if(a) {
					form.action="clip.asp?act=action&type=a&do=approve";
					form.submit()
				}
			}
			function checkAll(obj) {				
				for(var i = 0; i < form.length; i++) {
					if(form[i].type == "checkbox" && obj.checked == true) {
						form[i].checked = true;
					}
					else {
						form[i].checked = false;
					}
				}			
			}
			</script>
		<%
		if(pageslink != "")
		{
			Response.Write("<div style='text-align:right;margin:5px;'>"+pageslink+"</div>\n");
		}			
	}
	rs.Close();
	rs = null;
}

function doApprove(ids)
{
	if(ids != 0) {
		conn.Execute ("update mc_clips set approve=1 where id in("+ids+")");
	}
	else
	{
		var id = Request.QueryString("id");			
		conn.Execute ("update mc_clips set approve=1 where id="+id);
	}	
	var type = Request.QueryString("type");	
	var url = Request.ServerVariables("HTTP_REFERER");
	var m = /edit/
	if(m.test(url)) {
		redirect(21, "clip.asp?act=edit&type="+type+"&id="+id);
	}	
	redirect(21, "clip.asp?act=waitting");
}

function doUnApprove(ids)
{
	if(ids != 0) {
		Response.Write(ids);
		conn.Execute ("update mc_clips set approve=0 where id in("+ids+")");
	}
	else
	{
		var id = Request.QueryString("id");			
		conn.Execute ("update mc_clips set approve=0 where id="+id);
	}	
	
	var type = Request.QueryString("type");	
	var url = Request.ServerVariables("HTTP_REFERER");
	var m = /edit/
	if(m.test(url)) {
		redirect(22, "clip.asp?act=edit&type="+type+"&id="+id);
	}	
	redirect(22, "clip.asp");
}

function viewReportList()
{
	//Build query string
	var current_page		= 1;
	var perpage 			= 10;
	
	if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
	{
		current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
	}
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.CursorLocation = 3; 
	rs.PageSize       = perpage; 
	rs.CacheSize      = perpage;
	
	var query = "SELECT id,mc_clips.title as clip_title,cast(date_added as date) as clip_date,fullname,username,mc_channel.title as channel_title FROM mc_clips inner join mc_users on(uid=submiter) inner join mc_channel on(cid=chanel_id)  where id in( select distinct clip_id from mc_report) ";
	
	var url= "clip.asp?act=reportlist";
	//Build Filter
	//channel
	if(isset(Request.QueryString("channel")) && intval(Request.QueryString("channel")) > 0 )
	{
		query += "and chanel_id="+intval(Request.QueryString("channel"));
		url += "&channel="+intval(Request.QueryString("channel"));
	}
	//Username
	if(isset(Request.QueryString("username")) && Request.QueryString("username") != "" )
	{
		query += " and username like '" + safe_query(Request.QueryString("username")) + "%'";
		url += "&username="+Request.QueryString("username");
	}
	//Fullname
	if(isset(Request.QueryString("fullname")) && Request.QueryString("fullname") != "" )
	{
		query += " and fullname like '"+ safe_query(Request.QueryString("fullname")) + "%'";
		url += "&fullname="+Request.QueryString("fullname");
	}	
	//Clipname
	if(isset(Request.QueryString("clipname")) && Request.QueryString("clipname") != "" )
	{
		query += " and mc_clips.title like '"+ safe_query(Request.QueryString("clipname")) + "%'";
		url += "&clipname="+Request.QueryString("clipname");
	}	
	query += " order by id DESC";	
	
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, url);
			
	if(total == 0)
	{
		Response.Write("Lucky! No clip was reported as error.");
	}
	else
	{
		var i = 0;
		rs.AbsolutePage = current_page;
		
		%>
		<form method="post" id="clipfrom">
		<table class="listing">	
			<tr>
				<th width="1%"><input type="checkbox" onClick="checkAll(this)" /></th>
				<th width="10%">Username</th>
				<th width="15%">Fullname</th>
				<th width="37%">Clip</th>
				<th width="15%">Channel</th>				
				<th width="10%">On</th>	
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
			</tr>
		<%
	
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{			
			%>
				<tr>
					<td><input type="checkbox" name="clip_id" value="<%=rs("id")%>"/></td>
					<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
					<td style="text-align:left;"><%=(rs("fullname"))%></td>
					<td style="text-align:left;"><a href="../default.asp?act=clip&do=view&id=<%=rs("id")%>" alt="view clip" target="_blank"><%=(rs("clip_title"))%></a></td>
					<td style="text-align:left;"><%=(rs("channel_title"))%></td>
					<td style="text-align:left;"><%=(rs("clip_date"))%></td>					
					<td>
						<a href="clip.asp?act=view-report&type=c&id=<%=rs("id")%>"><img src="img/view.gif" alt="View Report" title="View Report"/></a>
					</td>
					<td>
						<a href="clip.asp?act=edit&type=c&id=<%=rs("id")%>"><img src="img/edit-icon.gif" alt="Edit Clip" title="Edit Clip"/></a>
					</td>
					<td>
						<a href="#" onClick="removeCLip('clip.asp?act=delete&type=c&id=<%=rs("id")%>');"><img src="img/hr.gif" alt="Delete Clip" title="Delete Clip"/></a>
					</td>
					<td>
						<a href="clip.asp?act=solve&type=c&id=<%=rs("id")%>"><img src="img/verify.png" alt="Solved Report" title="Solved Report"/></a>						
					</td>
				</tr>
			<%
			rs.MoveNext;
		}
		
		%>
			<tr>
				<th colspan="9">
					<input type="button" value="Remove reported Clips" onClick="removeClips()"/>					
				</th>
			</tr>
		<%
			
		Response.Write("</table></form>");
		%>
			<script type="text/javascript">
			var form = document.getElementById("clipfrom");
			function removeCLip(url)
			{
				var a = confirm("Are you sure to delete this clip?");
				if(a) {
					window.location = url;
				}
			}
			function removeClips(){
				var a = confirm("Are you sure want to delete selected clips?");
				if(a) {
					form.action="clip.asp?act=action&type=a&do=delete" ;
					form.submit()
				}
				
			}			
			function checkAll(obj) {				
				for(var i = 0; i < form.length; i++) {
					if(form[i].type == "checkbox" && obj.checked == true) {
						form[i].checked = true;
					}
					else {
						form[i].checked = false;
					}
				}			
			}
			</script>
		<%
		if(pageslink != "")
		{
			Response.Write("<div style='text-align:right;margin:5px;'>"+pageslink+"</div>\n");
		}			
	}
	rs.Close();
	rs = null;
}

function viewReportDetails()
{
	//Build query string
	var current_page		= 1;
	var perpage 			= 10;
	
	if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
	{
		current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
	}
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.CursorLocation = 3; 
		
	var query = "SELECT r.*, c.title, u.fullname, u.username FROM mc_report as r inner join mc_users as u on(u.uid = r.user_id) inner join mc_clips as c on(c.id = r.clip_id) where clip_id="+intval(Request.QueryString("id"));	
	
	query += " order by id DESC";	
	
	rs.Open(query, conn);
	
	var total = rs.PageCount;
			
	if(total == 0)
	{
		Response.Write("No report was found");
	}
	else
	{
		var i = 1;				
		%>
		<form method="post" id="clipfrom">
		<table class="listing">	
			<tr>
				<th width="3%"></th>
				<th width="10%">Username</th>
				<th width="15%">Fullname</th>
				<th width="27%">Clip</th>								
				<th width="10%">On</th>	
				<th width="35%">Comment</th>				
			</tr>
		<%
	
		while(! rs.EOF)
		{			
			%>
				<tr>
					<td><%=i%></td>
					<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
					<td style="text-align:left;"><%=(rs("fullname"))%></td>
					<td style="text-align:left;"><a href="../default.asp?act=clip&do=view&id=<%=rs("clip_id")%>" alt="view clip" target="_blank"><%=(rs("title"))%></a></td>
					<td style="text-align:left;"><%=(rs("report_date"))%></td>					
					<td>
						<%=rs("comment")%>		
					</td>
				</tr>
			<%
			i++;
			rs.MoveNext;
		}	
		Response.Write("</table></form>");		
	}
	rs.Close();
	rs = null;
}

function deleteClip(ids)
{
	
	if(ids != 0 ){
		var idarray = String(ids).split(",");				
		for(var i = 0; i < idarray.length; i++) {
			rs = Server.CreateObject("ADODB.Recordset");
			rs.CursorLocation = 3; 
			var query = "exec removeClips "+trim(idarray[i]);
			rs.open(query, conn);
			while(! rs.EOF)
			{
				unlink(config["upload_path"]+"/"+trim(rs("path")));
				unlink(config["upload_path"]+"/"+trim(rs("image")));
				rs.MoveNext;
			}
			rs.Close();
			rs = null;			
		}	
	}
	else {
		var id = Request.QueryString("id");	
		rs = Server.CreateObject("ADODB.Recordset");
		rs.CursorLocation = 3; 
		rs.open("exec removeClips "+id, conn);
		if(!rs.EOF) {
			rs.MoveFirst;
			unlink(config["upload_path"]+"/"+trim(rs("path")));
			unlink(config["upload_path"]+"/"+trim(rs("image")));
		}
		rs.Close();
		rs = null;
	}
	
	
	
	var type = Request.QueryString("type");		
	if(type == "b") {
		redirect(20, "clip.asp?act=waitting");
	}
	redirect(20, "clip.asp");
}

function editClipDetails()
{
	var id = intval(Request.QueryString("id"));
	var type = Request.QueryString("type");
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT c.*, u.username, u.fullname FROM mc_clips as c inner join mc_users as u on(u.uid = c.submiter) where c.id="+id, conn);	
	
	if(!rs.EOF)
	{
		rs.moveFirst;		
		
		%>
			<form action="clip.asp?act=updateclip" method="post">
			<input type="hidden" name="id" value="<%=rs("id")%>">
			<table class="listing">	
			<tr>
				<th width="20%"></th>
				<th></th>
			</tr>
			<tr>
				<td style="font-weight:bold">Login Name</td>
				<td style="text-align:left"><%=rs("username")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Full Name</td>
				<td style="text-align:left"><%=rs("fullname")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Date Added</td>
				<td style="text-align:left"><%=rs("date_added")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Clip name</td>
				<td style="text-align:left"><input name="clipname" value="<%=rs("title")%>"></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Channel Title</td>
				<td style="text-align:left">
					<select name="channel_id">
					<%
					
					var srs = Server.CreateObject("ADODB.Recordset");
					srs.Open("SELECT cid, title  FROM mc_channel ORDER BY title ASC", conn);
					
					while(! srs.EOF)
					{
						Response.Write("<option value='"+srs("cid")+"' "+((intval(srs("cid")) == intval(rs("chanel_id"))) ? "selected='selected'" : "")+">"+srs("title")+"</option>" );
						srs.MoveNext;
					}
					
					srs.Close();
					srs = null;					
					%>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<div style="font-weight:bold; background-color: #ececec; z-index: 1; padding-left: 5px;">Description content:</div>
				<div style="padding:15px 15px 10px 10px;border: 1px solid #c2c2c2; margin-top: -5px;">
					<textarea name="description" style="width: 100%;"><%=rs("description")%></textarea>
				</div>
				</td>				
			</tr>
			<tr>
				<td style="font-weight:bold">Clip File</td>
				<td style="text-align:left"><%=rs("path")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Image File</td>
				<td style="text-align:left"><%=rs("image")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Private mode?</td>
				<td style="text-align:left"><%=(rs("private") == 0) ? "No, other users can see it" : "Yes, only submiter can view this clip"%></td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:center">
				<%
					if(intval(rs("approve")) == 0) {
					%>
					<input type="button" onclick="window.location = 'clip.asp?act=approve&type=<%=type%>&id=<%=rs("id")%>'" value="Approve" />
					<%					
					}
					else {
					%>
					<input type="button" onclick="window.location = 'clip.asp?act=deny&type=<%=type%>&id=<%=rs("id")%>'" value="Deny" />
					<%
					}
					
				%>
					<input type="button" onclick="window.location = 'clip.asp?act=delete&type=<%=type%>&id=<%=rs("id")%>'" value="Delete" />
					<input type="submit" value="Update" />
					<input type="reset" value="Cancel" />
				</td>				
			</tr>			
		</table>	
		</form>	
		<%
		
	}
	else
	{
		Response.Write("No Clip found!");
	}
}

function doeditClipDetails() 
{
	var id = intval(Request.Form("id"));
	var title = safe_query(Request.Form("clipname"));
	var description = safe_query(Request.Form("description"));
	var chanel_id = intval(Request.Form("channel_id"));
	
	conn.Execute ("update mc_clips set title ='"+safe_query(title)+"', description='"+description+"', chanel_id='"+chanel_id+"' where id="+id);
	redirect(23, "clip.asp?act=edit&type=a&id="+id);
}

%>  
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->