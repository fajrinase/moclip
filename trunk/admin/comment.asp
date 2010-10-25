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
                <li><a href="user.asp">Users</a></li>
                <li><a href="clip.asp">Clips</a></li>
                <li><a href="channel.asp">Channel</a></li>
                <li><a href="comment.asp"  class="active">Comments</a></li>
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
					<li><a href="comment.asp">Approved List</a></li>
					<li><a href="comment.asp?act=aprrovelist">Not Approved list</a></li>
				</ul>                
			 </div>
			<div id="center-column">
				<div class="table">
<%

function showAllComments()
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
	
	var query = "SELECT com.id, com.date_added as com_date, com.title as com_title, u.username, u.fullname, u.sex, c.title, com.title as com_title FROM mc_comments as com inner join mc_users as u on(u.uid = com.user_id) inner join mc_clips as c on(c.id = com.clip_id) where com.approve = 1 order by id DESC";
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, "comment.asp");
			
	if(total == 0)
	{
		Response.Write("No comment was displayed");
	}
	else
	{
		var i = 0;
		rs.AbsolutePage = current_page;
		
		%>
		<table class="listing">	
			<tr>
				<th width="1%">&nbsp;</th>
				<th width="10%">Username</th>
				<th width="10%">Fullname</th>
				<th width="25%">Clip</th>
				<th width="25%">Comment Title</th>				
				<th width="19%">On</th>	
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
			</tr>
		<%
	
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{			
			%>
				<tr>
					<td><img alt="sex" src="img/<%=(intval(rs("sex")) == 1 ? "male3.png" : "female.gif")%>"/></td>
					<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
					<td style="text-align:left;"><%=(rs("fullname"))%></td>
					<td style="text-align:left;"><%=(rs("title"))%></td>
					<td style="text-align:left;"><%=(rs("com_title"))%></td>
					<td style="text-align:left;"><%=(rs("com_date"))%></td>					
					<td>
						<a href="comment.asp?act=view&type=a&id=<%=rs("id")%>"><img src="img/view.gif" alt="View" title="View"/></a>						
					</td>
					<td>
						<a href="#" onClick="removeCLip('comment.asp?act=delete&type=a&id=<%=rs("id")%>');"><img src="img/hr.gif" alt="Delete" title="Delete"/></a>
					</td>
					<td>
						<a href="comment.asp?act=unapprove&id=<%=rs("id")%>"><img src="img/stop.gif" alt="Edit" title="Unapprove"/></a>						
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
				var a = confirm("Are you sure to delete this comment?");
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

function showUnApproveList()
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
	
	var query = "SELECT com.id, com.date_added as com_date, com.title as com_title, u.username, u.fullname, u.sex, c.title, com.title as com_title FROM mc_comments as com inner join mc_users as u on(u.uid = com.user_id) inner join mc_clips as c on(c.id = com.clip_id) where com.approve=0 order by id DESC";
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, "comment.asp?act=aprrovelist");
			
	if(total == 0)
	{
		Response.Write("All comment was displayed, none has been hidden");
	}
	else
	{
		var i = 0;
		rs.AbsolutePage = current_page;
		
		%>
		<table class="listing">	
			<tr>
				<th width="1%">&nbsp;</th>
				<th width="10%">Username</th>
				<th width="10%">Fullname</th>
				<th width="25%">Clip</th>
				<th width="25%">Comment Title</th>				
				<th width="19%">On</th>	
				<th width="3%">&nbsp;</th>	
				<th width="3%">&nbsp;</th>
				<th width="3%">&nbsp;</th>
			</tr>
		<%
	
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{			
		%>
			<tr>
				<td><img alt="sex" src="img/<%=(intval(rs("sex")) == 1 ? "male3.png" : "female.gif")%>"/></td>
				<td style="text-align:left; font-weight:bold;"><%=(rs("username"))%></td>
				<td style="text-align:left;"><%=(rs("fullname"))%></td>
				<td style="text-align:left;"><%=(rs("title"))%></td>
				<td style="text-align:left;"><%=(rs("com_title"))%></td>
				<td style="text-align:left;"><%=(rs("com_date"))%></td>					
				<td>
					<a href="comment.asp?act=view&type=b&id=<%=rs("id")%>"><img src="img/view.gif" alt="View" title="View"/></a>						
				</td>
				<td>
					<a href="#" onClick="removeCLip('comment.asp?act=delete&type=b&id=<%=rs("id")%>');"><img src="img/hr.gif" alt="Delete" title="Delete"/></a>
				</td>
				<td>
					<a href="comment.asp?act=approve&id=<%=rs("id")%>"><img src="img/add-icon.gif" alt="Approve" title="Approve"/></a>						
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
				var a = confirm("Are you sure to do delete this comment?");
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
	var id = intval(Request.QueryString("id"));
	var type = Request.QueryString("type");
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT com.id, com.approve, com.date_added as com_date, com.title as com_title, com.comment, u.username, u.fullname, u.sex, c.title FROM mc_comments as com inner join mc_users as u on(u.uid = com.user_id) inner join mc_clips as c on(c.id = com.clip_id) where com.id="+id, conn);	
	
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
				<td style="font-weight:bold">Date Added</td>
				<td style="text-align:left"><%=rs("com_date")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">In Clip</td>
				<td style="text-align:left"><%=rs("title")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Comment Title</td>
				<td style="text-align:left"><%=rs("com_title")%></td>
			</tr>
			<tr>
				<td colspan="2">
				<div style="font-weight:bold; background-color: #ececec; z-index: 1; padding-left: 5px;">Comment content:</div>
				<div style="padding:15px 10px;border: 1px solid #c2c2c2; margin-top: -5px;">
					<%=rs("comment")%>
				</div>
				</td>				
			</tr>
			<tr>
				<td colspan="2" style="text-align:center">
				<%
					if(intval(rs("approve")) == 0) {
					%>
					<input type="button" onclick="window.location = 'comment.asp?act=unapprove&id=<%=rs("id")%>'" value="Approve" />
					<%					
					}
					else {
					%>
					<input type="button" onclick="window.location = 'comment.asp?act=approve&id=<%=rs("id")%>'" value="Un-Approve" />
					<%
					}
					
				%>
					<input type="button" onclick="window.location = 'comment.asp?act=delete&type=<%=type%>&id=<%=rs("id")%>'" value="Delete" />
				</td>				
			</tr>			
		</table>		
		<%
		
	}
	else
	{
		Response.Write("No comment found!");
	}
}

function doApprove()
{
	var id = intval(Request.QueryString("id"));	
	conn.Execute ("update mc_comments set approve=1 where id="+id);
	
	redirect(11, "comment.asp?act=aprrovelist");
}
function dounApprove()
{
	var id = Request.QueryString("id");	
	conn.Execute ("update mc_comments set approve=0 where id="+id);
	redirect(12, "comment.asp");
}

function doDelete()
{
	var id = intval(Request.QueryString("id"));	
	var type =  Request.QueryString("type");	
	conn.Execute ("delete from mc_comments where id="+id);
	if(type  == "a") {
		redirect(10, "comment.asp");
	}
	else {
		redirect(10, "comment.asp?act=aprrovelist");
	}
	
	
}
	
var action = Request.QueryString("act");

if(action == "aprrovelist")
{
	showUnApproveList();
}
else if(action == "view")
{
	viewDetails();
}
else if(action == "approve")
{
	doApprove();
}
else if(action == "unapprove")
{
	dounApprove();
}
else if(action == "delete")
{
	doDelete();
}
else
{
	showAllComments();
}

%>				   
				</div>						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->