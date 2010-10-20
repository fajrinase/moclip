<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual ="moclip/include/config.asp" -->
<!--#include virtual ="moclip/include/function.asp" -->
<!--#include virtual ="moclip/include/DBinit.asp" -->
<%

var action = new String(Request.QueryString("act")).toString();

%>
<!--#include file="public/header.asp"-->
		<div id="header">
            <a href="#" class="logo">MoClip!</a>
            <ul id="top-navigation">
                <li><a href="admin.asp" >Homepage</a></li>
                <li><a href="user.asp">Users</a></li>
                <li><a href="clip.asp">Clips</a></li>
                <li><a href="channel.asp"  class="active">Channel</a></li>
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
					<li><a href="?">List Channel</a></li>
					<li><a href="?act=add">Add Channel</a></li>
				</ul>                
			 </div>
			<div id="center-column">
				<div class="top-bar">
					<%
						if(action != "add" && action != "edit")
						{
							Response.Write("<div>Quick add channel</div>");
							addChannel();							
						}
						else 
						{
							if(action == "edit")
								Response.Write("<div>Edit channel</div>");
							else
								Response.Write("<div>Add new channel</div>");
						}
					%>					
				</div>
				
				<div class="table">
<%

if(action == "list")
{
	listChanel();
}
else if(action == "add")
{
	addChannel("add");
}
else if(action == "sync")
{
	syncChannel();
}
else if(action == "doadd")
{
	doaddChannel("add");
}
else if(action == "edit")
{
	addChannel("edit");
}
else if(action == "doedit")
{
	doaddChannel("edit");
}
else if(action == "delete")
{
	deleteChannel();
}
else
{
	listChannel();
}

function listChannel()
{
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT cid, title, total_clips  FROM mc_channel ORDER BY cid ASC", conn);
	%>
		<table class="listing">	
			<tr>
				<th width="1%">ID</th>
				<th width="65%">Title</th>
				<th width="19%">Total Clip</th>
				<th width="5%">&nbsp;</th>
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
					<a href="channel.asp?act=sync&cid=<%=rs("cid")%>"><img src="img/sync.png"-icon.gif" alt="Sync" title="Sync"/></a>					
				</td>
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

function addChannel(type)
{
	var title = "";
	var cid = intval(Request.QueryString("cid"));
		
	if(type == "edit" && cid > 0)
	{
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT cid, title FROM mc_channel where cid="+cid, conn);
		if(!rs.EOF) {
			rs.moveFirst;
			title = trim(new String(rs("title")).toString());
		}
		else {
			Response.Write("No channel found. Will add new channel when you submit.");
		}
	}
	%>
		<form action="?act=<%=(type == "edit") ? "doedit" : "doadd"%>" method="post" onSubmit="return checkForm(this)">
							<input type="text" name="title" value="<%=title%>" />
							<input type="submit" value="<%=(type == "edit") ? "Update" : "Add"%>" />
							<input type="hidden" name="cid" value="<%=cid%>" />
		</form>
		<script type="text/javascript">
			function checkForm(obj) {
				if(obj.title.value == "")
				{
					alert("Title is Blank!");
					obj.title.focus();
					return false;
				}
				if(obj.title.value.length < 4)
				{
					alert("Title is too short!");
					obj.title.focus();
					return false;
				}
				return true;
			}
		</script>
	<%	
}


function doaddChannel(type)
{
	var title = new String(Request.Form("title")).toString();

	if( isset(title) )
	{
		if(type == "edit")
		{
			var cid = intval(Request.Form("cid"));
			conn.Execute ("update mc_channel set title ='"+safe_query(title)+"' where cid="+cid);
			redirect(7, "channel.asp");
		}
		else
		{
			conn.Execute ("insert into mc_channel (title) values('"+safe_query(title)+"')");
			redirect(5, "channel.asp");
		}
	}
	else
	{
		Response.Write("Error! Can not "+type+".");
	}
}

function deleteChannel()
{
	var cid = intval(Request.QueryString("cid"));
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT cid FROM mc_channel where cid="+cid, conn);
	
	if(!rs.EOF)
	{
		rs.moveFirst;
		
		//Delete all clips in channel	
		if( intval(rs("cid")) > 0 )
		{
			conn.Execute ("exec removeChannel "+cid);
			redirect(6, "channel.asp");
		}
	}
	else
	{
		Response.Write("Cannot find a channel");
	}
	
	rs.Close();
	rs = null;
}

function syncChannel() {
	var cid = intval(Request.QueryString("cid"));
	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open("SELECT cid FROM mc_channel where cid="+cid, conn);
	
	if(!rs.EOF)
	{
		rs.moveFirst;
		
		//Delete all clips in channel	
		if( intval(rs("cid")) > 0 )
		{
			conn.Execute ("exec updateChannel "+cid);
			redirect(8, "channel.asp");
		}
	}
	else
	{
		Response.Write("Cannot find a channel");
	}
	
	rs.Close();
	rs = null;
}


%>
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->