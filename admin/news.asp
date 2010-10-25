<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>

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
				<div class="table">
<%

action = Request.QueryString("act");

if(action == "new")
{
	postNews("new");
}
else if(action == "edit")
{
	postNews("edit");
}
else if(action == "doedit")
{
	dopostNews("edit");
}
else if(action == "delete")
{
	deleteNews();
}
else if(action == "donew")
{
	dopostNews("new");
}
else
{
	listNews();
}

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
				<td><%=rs("nid")%></td>
				<td style="text-align:left; font-weight:bold;"><%=rs("title")%></td>
				<td><%=rs("date_added")%></td>
				<td>
					<a href="news.asp?act=edit&nid=<%=rs("nid")%>"><img src="img/edit-icon.gif" alt="Edit" title="Edit"/></a>					
				</td>
				<td>
					<a href="#" onclick="removeCLip('news.asp?act=delete&nid=<%=rs("nid")%>');"><img src="img/hr.gif" alt="Delete" title="Delete"/></a>
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
	var title, content, date_added, image, description, submiter, nid;	
	if(type == "edit")
	{	
		if( intval(Request.Form("nid")) > 0)
		{
			nid = intval(Request.From("nid")) 
		}
		else
		{
			nid = intval(Request.QueryString("nid")) 
		}
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT nid, title, content, description, date_added, image FROM mc_news where nid="+nid, conn);
		
		if(!rs.EOF)
		{
			rs.MoveFirst;
			
			title = trim(rs("title"));
			content = trim(rs("content"));
			date_added = trim(rs("date_added"));
			image =  trim(rs("image"));;
			description = trim(rs("description"));;
			nid = intval(rs("nid"));
		}
	}
	
	%>
		<script type="text/javascript" src="../public/js/tiny_mce/tiny_mce.js"></script>
		<script type="text/javascript">
			tinyMCE.init({
		mode : "exact",
		elements : "elm1",
		theme : "advanced",
		plugins : "pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,autosave",

		// Theme options
		theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
		theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
		theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
		theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,template,pagebreak,restoredraft",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,

		// Example content CSS (should be your site CSS)
		content_css : "css/content.css",

		// Drop lists for link/image/media/template dialogs
		template_external_list_url : "lists/template_list.js",
		external_link_list_url : "lists/link_list.js",
		external_image_list_url : "lists/image_list.js",
		media_external_list_url : "lists/media_list.js",

		// Style formats
		style_formats : [
			{title : 'Bold text', inline : 'b'},
			{title : 'Red text', inline : 'span', styles : {color : '#ff0000'}},
			{title : 'Red header', block : 'h1', styles : {color : '#ff0000'}},
			{title : 'Example 1', inline : 'span', classes : 'example1'},
			{title : 'Example 2', inline : 'span', classes : 'example2'},
			{title : 'Table styles'},
			{title : 'Table row 1', selector : 'tr', classes : 'tablerow1'}
		],
		});
		</script>

		<form method="POST" action="news.asp?act=<%=((type=="edit") ? "doedit" : "donew")%>" method="enctype="multipart/form-data">
			<input type="hidden" name="nid" value="<%=nid%>">
			<table class="listing">
				<tr>
					<td style="width: 20%">Title</td>
					<td style="width: 60%"><input style="width: 60%" type="text" name="title" value="<%=title%>"></td>
				</tr>
				<tr>
					<td style="width: 20%">Description</td>
					<td style="width: 60%"><textarea style="width: 60%" name="description"><%=description%></textarea></td>
				</tr>
				<tr>
					<td style="width: 20%">Image</td>
					<td style="width: 60%"><input type="text" style="width: 60%" name="image" value="<%=image%>" /></td>
				</tr>
				<tr>
					<td colspan="2">Content</td>					
				</tr>	
				<tr>
					<td colspan="2" style="text-align: center;"><textarea id="elm1" name="content" rows="15" cols="80" style="width:99%;"><%=content%></textarea></td>					
				</tr>	
				
				<tr>
					<td colspan="2" style="text-align: center;">
						<input type="submit" value="<%=(type=="edit" ? "Update" : "Add")%>" />
						<input type="reset" value="Cancel" />
					</td>	
				</tr>
			</table>
		</fom>
	<%
	
}

function dopostNews(type) 
{
	title = safe_query(trim(Request.Form("title")));
	
	content = safe_query(trim(Request.Form("content")));	
	image =  safe_query(trim(Request.Form("image")));
	description = safe_query(trim(Request.Form("description")));
		
	if(type == "edit") 
	{
		nid = intval(Request.Form("nid"));
		conn.Execute("update mc_news set title='"+title+"', content='"+content+"', date_added='"+now+"', image='"+image+"', description='"+description+"' where nid="+nid+"");
	}
	else
	{
		var query = "insert into mc_news values('"+title+"', '"+content+"', '"+now+"', "+admin["id"]+", '"+image+"', '"+description+"')";
		conn.Execute(query);
	}
	
	redirect(30,"news.asp");
}

function deleteNews()
{
	var nid = intval(Request.QueryString("nid"));
	if(nid > 0)
		conn.Execute("delete from mc_news where nid="+nid);
		
	redirect(31,"news.asp");
}

%>				   
				</div>
						   
			</div>            
		</div><!--Ennd main-->
<!--#include file="public/footer.asp"-->