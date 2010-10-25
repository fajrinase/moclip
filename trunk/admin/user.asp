<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual ="moclip/include/config.asp" -->
<!--#include virtual ="moclip/include/function.asp" -->
<!--#include virtual ="moclip/include/DBinit.asp" -->

<!--#include file="public/header.asp"-->
		<div id="header">
            <a href="#" class="logo">MoClip!</a>
            <ul id="top-navigation">
                <li><a href="admin.asp" >Homepage</a></li>
                <li><a href="user.asp" class="active">Users</a></li>
                <li><a href="clip.asp">Clips</a></li>
                <li><a href="channel.asp">Channel</a></li>
                <li><a href="comment.asp">Comments</a></li>
                <li><a href="news.asp">News</a></li>
                <li><a href="system.asp">System</a></li>
                <li><a href="suggestion.asp">Suggestion</a></li>
				<li><a href="admin.asp?act=logout">Logout</a></li>
            </ul>
        </div>
		
 		<div id="middle">
			<div id="left-column">
				<h3>Menu</h3>
				<ul class="nav">
					<li><a href="user.asp">List Users</a></li>				
				</ul>                
			 </div>
			<div id="center-column">
				<div class="table">
<%
function listAll()
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
	
	var query = "SELECT * from mc_users";
	
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
						<a href="user.asp?act=view&uid=<%=rs("uid")%>"><img src="img/view.gif" alt="Edit"/></a>						
					</td>
					<td>
						<!--<a href="#" onclick="removeCLip('user.asp?act=delete&uid=<%=rs("uid")%>');"><img src="img/hr.gif" alt="Edit"/></a>-->
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
				var a = confirm("Are you sure to do delete this user?");
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


function viewDetails()
{
	var uid = intval(Request.QueryString("uid"));
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT * FROM mc_users where uid="+uid, conn);	
	
	if(!rs.EOF)
	{
		rs.moveFirst;
	%>
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
				<td style="font-weight:bold">Email</td>
				<td style="text-align:left"><%=rs("email")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Address</td>
				<td style="text-align:left"><%=rs("address")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Phone</td>
				<td style="text-align:left"><%=rs("phone")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Moblie</td>
				<td style="text-align:left"><%=rs("mobile")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Date joined</td>
				<td style="text-align:left"><%=rs("date_joined")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Security Question</td>
				<td style="text-align:left"><%=rs("question")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Security Answer</td>
				<td style="text-align:left"><%=rs("answer")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Allow to Access Admin?</td>
				<td style="text-align:left"><%=(intval(rs("allow_acp")) == 0) ? "<a href='system.asp?act=grant&uid="+rs("uid")+"'>Click here to <b>allow</b> this user access Admin Panel</a>" : "<a href='system.asp?act=remove&uid="+rs("uid")+"'>Click here to <b>disallow</b> this user access Admin Panel</a>" %></td>
			</tr>
		</table>
	<%	
	}
	else
	{
		Response.Write("No user found!");
	}
}

action = Request.QueryString("act");

if(action == "view")
{
	viewDetails();
}
else
{
	listAll();
}
%>				   
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->