<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual ="moclip/include/config.asp" -->
<!--#include virtual ="moclip/include/function.asp" -->
<!--#include virtual ="moclip/include/DBinit.asp" -->


<!--#include file="public/header.asp"-->
		<div id="header">
            <a href="#" class="logo">MoClip!</a>
            <ul id="top-navigation">
                <li><a href="admin.asp">Homepage</a></li>
                <li><a href="user.asp">Users</a></li>
                <li><a href="clip.asp">Clips</a></li>
                <li><a href="channel.asp">Channel</a></li>
                <li><a href="comment.asp">Comments</a></li>
                <li><a href="system.asp" class="active">System</a></li>
                <li><a href="suggestion.asp">Suggestion</a></li>
				<li><a href="admin.asp?act=logout">Logout</a></li>
            </ul>
        </div>
		
 		<div id="middle">
			<div id="left-column">
				<h3>Menu</h3>
				<ul class="nav">
					<li><a href="#">List Administrator</a></li>				
				</ul>                
			 </div>
			<div id="center-column">
				<div class="top-bar">
					Administrators List
				</div>
				<div class="table">
<%

action = Request.QueryString("act");
if(action == "grant") {
	allow();
}
else if(action == "remove") {
	disallow();
}
else {
	listAdmin();
}





function allow()
{
	var id = Request.QueryString("uid");	
	conn.Execute ("update mc_users set allow_acp=1 where uid="+id);
	
	var url = Request.ServerVariables("HTTP_REFERER");
	var m = /user.asp/;
	
	if(m.test(url)) {
		redirect(15, "user.asp?act=view&uid="+id);
	}	
	redirect(15, "system.asp");
}


function disallow()
{
	var id = Request.QueryString("uid");	
	if(id > 1)
	{
		conn.Execute ("update mc_users set allow_acp=0 where uid="+id);
		
		var url = Request.ServerVariables("HTTP_REFERER");
		var m = /user.asp/;
		
		if(m.test(url)) {
			redirect(16, "user.asp?act=view&uid="+id);
		}
		redirect(16, "system.asp");
	}
	else
	{
		Response.Write("Error! You can't change root'permisstion");
	}
}

function listAdmin()
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
	
	var query = "SELECT * from mc_users where allow_acp=1";
	
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, "user.asp");
			
	if(total == 0)
	{
		Response.Write("No User");
	}
	else
	{
		var i = 0;
		rs.AbsolutePage = current_page;
		
		%>
		<table class="listing">	
			<tr>
				<th width="1%">Sex</th>
				<th width="10%">Username</th>
				<th width="20%">Fullname</th>
				<th width="20%">Email</th>
				<th width="15%">Phone</th>
				<th width="15%">Mobile</th>
				<th width="15%">Joined</th>	
				<th width="5%">&nbsp;</th>	
				<th width="1%">&nbsp;</th>			
			</tr>
		<%
	
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{
			
			%>
				<tr>
					<td><img alt="sex" src="img/<%=(intval(rs("sex")) == 1 ? "male3.png" : "female.gif")%>"/></td>
					<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
					<td style="text-align:left;"><%=(rs("fullname"))%></td>
					<td style="text-align:left;"><%=(rs("email"))%></td>
					<td style="text-align:left;"><%=(rs("phone"))%></td>
					<td style="text-align:left;"><%=(rs("mobile"))%></td>
					<td style="text-align:left;"><%=(rs("date_joined"))%></td>
					<td>
						<a href="user.asp?act=view&uid=<%=rs("uid")%>"><img src="img/view.gif" alt="View" title="View"/></a>						
					</td>
					<td>
						<a href="#" onclick="removeCLip('system.asp?act=remove&uid=<%=rs("uid")%>');"><img src="img/stop.gif" alt="Remove Admin" title="Remove Admin"/></a>
					</td>
				</tr>
			<%
			rs.MoveNext;
		}
			
		Response.Write("</table>");
		%>
			<script type="text/javascript">
			function removeCLip(url)
			{
				var a = confirm("Are you sure want to disallow this user access Admin?");
				if(a) {
					window.location = url;
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

%>				   
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->