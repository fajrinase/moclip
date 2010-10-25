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
                <li><a href="comment.asp">Comments</a></li>
				<li><a href="news.asp">News</a></li>
                <li><a href="system.asp">System</a></li>
                <li><a href="suggestion.asp" class="active">Suggestion</a></li>
				<li><a href="admin.asp?act=logout">Logout</a></li>
            </ul>
        </div>
		
 		<div id="middle">
			<div id="left-column">
				<h3>Menu</h3>
				<ul class="nav">
					<li><a href="suggestion.asp">List All</a></li>				
				</ul>                
			 </div>
			<div id="center-column">
				<div class="top-bar">
					
				</div>
				
				<div class="table">
<%
var action = Request.QueryString("act");
if(action == "details") {
	details();
}
else {
	list();
}

%>				   
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->

<%
function details() 
{
	id = intval(Request.QueryString("id"));
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("select s.*, u.username, u.fullname from mc_suggestion as s left join mc_users as u on( u.uid = s.user_id) where s.id="+id, conn);	
	
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
				<td style="text-align:left"><%=rs("date_added")%></td>
			</tr>
			<tr>
				<td style="font-weight:bold">Title</td>
				<td style="text-align:left"><%=rs("title")%></td>
			</tr>
			<tr>
				<td colspan="2">
				<div style="font-weight:bold; background-color: #ececec; z-index: 1; padding-left: 5px;">Description content:</div>
				<div style="padding:15px 15px 10px 10px;border: 1px solid #c2c2c2; margin-top: -5px;">
					<textarea name="description" style="width: 100%;" disabled="disabled"><%=rs("content")%></textarea>
				</div>
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

function list()
{
	var query = "select s.*, u.username, u.fullname from mc_suggestion as s left join mc_users as u on( u.uid = s.user_id)";
	query += " order by s.id DESC";	
	
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
	
	rs.Open(query, conn);
	
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, "suggestion.asp");
	
	%>		
		<table class="listing">	
			<tr>
				<th width="1%"></th>
				<th width="14%">Username</th>
				<th width="15%">Fullname</th>
				<th width="50%">Title</th>						
				<th width="10%">On</th>	
				<th width="5%">&nbsp;</th>
				<th width="5%">&nbsp;</th>				
			</tr>
	<%
	
	if(total == 0)
	{
		Response.Write("<tr><td colspan='7' align='center'>No item</td></tr>");
	}
	else
	{
		var i = 1;
		rs.AbsolutePage = current_page;
		while(rs.AbsolutePage == current_page && ! rs.EOF)
		{	
			%>
			<tr>
			 	<td><%=i++%></td>
				<td><%=rs("username")%></td>
				<td><%=rs("fullname")%></td>
				<td class="style1"><%=rs("title")%></td>
				<td><%=rs("date_added")%></td>
				<td><a href="suggestion.asp?act=details&id=<%=rs("id")%>"><img alt="view" title="View" src="img/view.gif"/></a></td>
				<td></td>
			</tr>
			<%
			rs.MoveNext;
		}
				
	}
	
	%>
		</table>
	<%
	rs.Close();
	rs = null;
	
}
%>