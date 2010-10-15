<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include file="include/config.asp" -->
<!--#include file="include/function.asp" -->
<!--#include file="include/DBinit.asp" -->

<!--#include file="public/header.asp" -->
<%
var action = new String(Request.QueryString("act")).toString();


if(action == "channel") 
{
%>
<!--#include file="module/channel.asp" -->
<%
}

else if(action == "user") 
{
%>
<!--#include file="module/member.asp" -->
<%
}

else if(action == "upload") 
{
%>
<!--#include file="module/upload.asp" -->
<%
}

else if(action == "clip") 
{
%>
<!--#include file="module/clip.asp" -->
<%
}

else if(action == "register") 
{
	var acc = new Array();
%>
<!--#include file="module/register.asp" -->
<%
}

else if(action == "search") 
{
%>
<!--#include file="module/search.asp" -->
<%
}



else
{

	//Show lastest clip
	var query = "SELECT top 1 mc_channel.title as ctitle, mc_channel.cid as cid , c.*, mc_users.uid, username, fullname, rate_table.rate_percent, rate_table.rate_total";
	query += " FROM mc_clips as c";
	query += " INNER JOIN mc_channel  ON mc_channel.cid = c.chanel_id cross JOIN mc_users";
	query += " left join (select clip_id, avg(rate) as rate_percent, count(rate) as rate_total FROM mc_clip_rate GROUP BY clip_id) AS rate_table ON(rate_table.clip_id = c.id)";
	query += " order by id DESC";

	rs = Server.CreateObject("ADODB.Recordset");
	rs.Open(query, conn);
	
	if(! rs.EOF)
	{
		rs.MoveFirst;
		var image = "uploads/"+trim(new String(rs("image")).toString());
		var path = "../../uploads/"+trim(new String(rs("path")).toString());
		var title = trim(new String(rs("title")).toString());
		var desc = trim(new String(rs("description")).toString());
		var username = trim(new String(rs("username")).toString());
		var fullname = trim(new String(rs("fullname")).toString());
		var id = intval(new String(rs("id")));
		var uid = intval(new String(rs("uid")));
		var cid = intval(new String(rs("cid")));
		var rate = intval(new String(rs("rate_percent")));
		var rate_total = intval(new String(rs("rate_total")));
		var hits = intval(new String(rs("hits")));
		%>
		<div class="view-clip-title">Newest Clip <%=title%></div>
					<div id="obj-clip-player">
						<object id="player" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" name="player" width="100%" height="365">
							<param name="movie" value="public/flash/player.swf" />
							<param name="allowfullscreen" value="true" />
							<param name="allowscriptaccess" value="always" />							
							<param name="flashvars" value="file=<%=path%>&image=<%=image%>&skin=public/flash/icecreamsneaka.zip" />
							<embed
								type="application/x-shockwave-flash"
								id="player2"
								name="player2"
								src="public/flash/player.swf" 
								width="100%" 
								height="345"
								allowscriptaccess="always" 
								allowfullscreen="true"
								flashvars="file=<%=path%>&image=<%=image%>&skin=public/flash/icecreamsneaka.zip" 
							/>
						</object>
					</div>
		<%
		
	}
	
	rs.Close();
	rs = null;
	query = null;

	//Display all channel and one clip on this channel
	var squery = "select top 6 ch.cid, ch.title, c.id, c.title as clip_title, c.description, c.image, c.hits, rate_percent, rate_total from mc_channel as ch inner join mc_clips as c on(c.chanel_id = ch.cid) left join (select clip_id, avg(rate) as rate_percent, count(rate) as rate_total FROM mc_clip_rate GROUP BY clip_id) AS rate_table ON(rate_table.clip_id = c.id) where c.id in(select MAX(id) from mc_clips group by chanel_id) order by NEWID()";
	
	var srs = Server.CreateObject("ADODB.Recordset");
	srs.Open(squery, conn);
	
	Response.Write("<ul class='list-chanel'>");
	var i=1;	
	
	while(! srs.EOF) 
	{	
		
		image = trim(new String(srs("image")).toString());
		title = trim(new String(srs("title")).toString());
		clip_title = trim(new String(srs("clip_title")).toString());
		desc = trim(new String(srs("description")).toString());
		id = intval(new String(srs("id")));
		cid = intval(new String(srs("cid")));
		hits = intval(new String(srs("hits")));
		rate = intval(new String(srs("rate_percent")));
		rate_total = intval(new String(srs("rate_total")));
		
		%>
				<li class="column-channel-news">
					<div><a href="default.asp?act=channel&id=<%=cid%>" alt="<%=title%>"><%=title%></a></div>
					<div class="column-channel-news-image"><a href="default.asp?act=clip&do=view&id=<%=id%>" alt="<%=clip_title%>"><img src="image.asp?f=<%=image%>&w=180&h=150" alt="<%=clip_title%>"/></a></div>
					<div><a href="default.asp?act=clip&do=view&id=<%=id%>" alt="<%=clip_title%>"><%=clip_title%></a></div>
					<div><%=desc%></div>
					<div id="clip-start-rate-<%=id%>"></div>					
					<script type="text/javascript">
						new loadRatingModule({ id : "clip-start-rate-<%=id%>", rated : <%=rate%>, total : <%=rate_total%>, cid : <%=cid%>, allowRate : 2 });
					</script>
					<div>Hits <b><%=hits%></b></div>
				</li>				
		<%
		
		if((i++%3) == 0)
		{
			Response.Write("<li class='clip-column'></li>");
		}
		
		srs.MoveNext;
		
	}
	
	
	
	srs.Close();
	srs = null;
	//Response.Write("<li class='clip-column'></li>");
	Response.Write("</ul>");
	
	
	//show more clip
}

%>
<!--#include file="public/footer.asp" -->