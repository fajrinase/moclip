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
				<li><a href="news.asp" class="active">News</a></li>
                <li><a href="system.asp">System</a></li>
                <li><a href="suggestion.asp">Suggestion</a></li>
				<li><a href="admin.asp?act=logout">Logout</a></li>
            </ul>
        </div>
		
 		<div id="middle">
			<div id="left-column">
				<h3>Menu</h3>
				<ul class="nav">
					<li><a href="news.asp">List News</a></li>				
					<li><a href="news.asp?act=new">Add News</a></li>				
				</ul>                
			 </div>
			<div id="center-column">
				<div class="top-bar">
					List News
				</div>
				<div class="table">
<%

action = Request.QueryString("act");

listNews();

function listNews()
{
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT nid, title, date_added FROM mc_news ORDER BY nid ASC", conn);
	%>
		<table class="listing">	
			<tr>
				<th width="1%">ID</th>
				<th width="70%">Title</th>
				<th width="19%">Date</th>
				<th width="5%">&nbsp;</th>
				<th width="5%">&nbsp;</th>
			</tr>
	<%
	
	while(! rs.EOF)
	{
		%>
			<tr>
				<td><%=rs("cid")%></td>
				<td style="text-align:left; font-weight:bold;"><%=rs("title")%></td>
				<td><%=rs("total_clips")%></td>
				<td>
					<a href="channel.asp?act=edit&cid=<%=rs("cid")%>"><img src="img/edit-icon.gif" alt="Edit" title="Edit"/></a>					
				</td>
				<td>
					<a href="#" onclick="removeCLip('channel.asp?act=delete&cid=<%=rs("cid")%>');"><img src="img/hr.gif" alt="Delete" title="Delete"/></a>
				</td>
			</tr>
		<%
		rs.MoveNext;
	}	
	%>
		</table>
		<script type="text/javascript">
			function removeCLip(url)
			{
				var a = confirm("This will delete all clips in this Channel. Are you sure to do that?");
				if(a) {
					window.location = url;
				}
			}
		</script>
	<%	
	rs.Close();
	rs = null;

}

function postNews(type) 
{
	var title, content, date_added, image, description, submiter;
	if(type == "edit")
	{	
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT nid, title, date_added FROM mc_news ORDER BY nid ASC", conn);
		
		if(!rs.EOF)
		{
			rs.MoveFirst;
			title = trim(rs("title"));
			content = trim(rs("content"));
			date_added = trim(rs("date_added"));
			image =  trim(rs("image"));;
			description = trim(rs("description"));;
			submiter = intval(rs("submiter"));
		}
	}
	
	%>
			<table class="listing">
				<tr>
					<td style="width: 40%"></td>
					<td style="width: 60%"></td>
				</tr>
			</table>
	<%
	
}

%>				   
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->