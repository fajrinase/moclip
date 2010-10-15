<%

function viewClip()
{
	var id = intval(Request.QueryString("id"));
	
	rs = Server.CreateObject("ADODB.Recordset");
	
	var query = "SELECT top 1 mc_channel.title as ctitle, mc_channel.cid as cid , c.*, mc_users.uid, username, fullname, rate_table.rate_percent, rate_table.rate_total";
	query += " FROM mc_clips as c";
	query += " INNER JOIN mc_channel  ON mc_channel.cid = c.chanel_id cross JOIN mc_users";
	query += " left join (select clip_id, avg(rate) as rate_percent, count(rate) as rate_total FROM mc_clip_rate GROUP BY clip_id) AS rate_table ON(rate_table.clip_id = c.id)";
	query += "where id="+id;

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
						
			<table width="100%">
			<tr>
				<td width="65%" valign="top">
					<div class="view-clip-title"><%=title%></div>
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
					
					<div class="clip-view-extra-info">
						<span class="clip-view-report" onclick="reportThisClip(<%=id%>)">Report</span>
						<span class="clip-view-hits"><b><%=hits%></b> views</span>
						<%showClipRate(rate, rate_total, id, 1)%>
						<span style="clear:both"></span>
					</div>
					
					<div class="clip-view-comment-info">
						<%showClipComments(id)%>
					</div>
					
				</td>
				<td width="35%" valign="top">
					<div class="clip-view-submiter">
						<div class="clip-submiter"><span>Poster:</span> <a href="#"><%=fullname%></a></div>
						<div>On: <%=rs("date_added")%></div>
						<div>In channel: <a href="default.asp?act=channel&id=<%=rs("cid")%>" alt="View this Channel" title="View this Channel"><%=rs("ctitle")%></a></div>
					</div>
					
					<div class="clip-view-same">
<%
	//Display 10 from same cat
	var subrs = Server.CreateObject("ADODB.Recordset");
	subrs.Open("select top 8 title, id, image, hits, description from mc_clips where chanel_id='"+cid+"' order by NEWID() DESC", conn);
	
	Response.Write("<div>Same Clips</div>");
	Response.Write("<ul class='list-same-clips'>");
		
	while(! subrs.EOF)
	{
		var subimage = trim(new String(subrs("image")).toString());
		var subtitle = trim(new String(subrs("title")).toString());
		var subdesc = trim(new String(subrs("description")).toString());
		var subid = intval(new String(subrs("id")));
		var hits = intval(new String(subrs("hits")));
		
		%>
			<li class="view-clip-more-row">
				<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=subid%>" alt="">
					<div class='row-clip-image'><img src="image.asp?f=<%=subimage%>&w=80&h=150" alt="<%=subtitle%>"/></div>
					<div class='row-clip-title'><%=subtitle%></div>
					<div class='row-clip-desc'><%=subdesc%></div>
					<div class='row-clip-desc'>Hits: <b><%=hits%></b></div>
					<div class='clip-column'></div>
				</a>					
			</li>
			
		<%
		subrs.MoveNext;
	}
	subrs.Close();
	subrs = null;		
	
	Response.Write("</ul>");

%>
					</div>
				</td>
			</tr>
			</table>
		<%	
		
		//increase hits
		conn.Execute("update mc_clips set hits=hits+1 where id="+rs("id"));	
	}
	else
	{
		Response.Write("Invalid Clip");
	}
	
	rs.Close();
	rs = null;	
}


function showClipRate(rate, rate_total, id, allowRate)
{
	if(!user['id'])
	{
		allowRate = 0;
	}
	%>
		<span class="clip-view-rate">Rate! <span id='clip-start-rate'></span></span>
		<script type="text/javascript">
			new loadRatingModule({ id : "clip-start-rate", rated : <%=rate%>, total : <%=rate_total%>, cid : <%=id%>, allowRate : <%=allowRate%> });
		</script>
	<%
}

function showClipComments(id) 
{
	var subrs = Server.CreateObject("ADODB.Recordset");
	subrs.Open("select c.user_id, c.title, c.comment, u.fullname from mc_comments as c inner join mc_users as u on(c.user_id = u.uid) where c.clip_id='"+id+"' order by id DESC", conn);
	
	Response.Write("<div class='clip-list-comments-title'>Comments:</div>");
	Response.Write("<ul class='list-clip-comments'>");
		
	while(! subrs.EOF)
	{
		var fullname = trim(new String(subrs("fullname")).toString());
		var comment = trim(new String(subrs("comment")).toString());
		var title = trim(new String(subrs("title")).toString());		
		//var subdesc = trim(new String(subrs("user_id")).toString());
		
		var uid = intval(new String(subrs("user_id")));
		
		%>
			<li class="view-clip-comment-row">
				<div><span><b style="color: #FF3300"><%=fullname%></b> said:</span></div>
				<div><%=comment%></div>			
			</li>
			
		<%
		subrs.MoveNext;
	}
	
	Response.Write("</ul>");
	subrs.Close();
	subrs = null;
	
	if(user["id"] > 0)
	{
		%>
			<div class="post-comment">
				<input type="hidden" value="<%=id%>" id="comment-cid">
				<div><input type="text" name="Title" value="Title" onfocus='toggleContent(this);' id="comment-title"></div>
				<div><textarea name="comment" id="comment-content"></textarea></div>
				<div><input type="button" value="Comment" onclick="postaComment()"></div>
			</div>
		<%	
	}
	else
	{
		Response.Write("<div class='post-comment'>Please login to comment on this clip!</div>");	
	}
}

function rateClip()
{
	if(!user["id"])
	{
		Response.Write("<script>alert('You are not login'); window.close()</script>");
	}
	else
	{
		var id = intval(Request.QueryString("cid"));
		var p = intval(Request.QueryString("p"));
		
		var query = "insert into mc_clip_rate (clip_id, rate, user_id) values("+id+","+p+","+user["id"]+")";
		
		conn.Execute(query);
		Response.Write("<script>alert('Your rate was susscessfull added'); window.close()</script>");
	}
}

function commentClip()
{
	if(!user["id"])
	{
		Response.Write("<script>alert('You are not login'); window.close()</script>");
	}
	else
	{
		var id = intval(Request.QueryString("cid"));
		var title = safe_query(Request.QueryString("title"));
		var content = safe_query(Request.QueryString("content"));
		
		var query = "insert into mc_comments (clip_id, user_id, title, comment) values("+id+","+user["id"]+", '"+title+"', '"+content+"')";
		
		conn.Execute(query);
		Response.Write("<script>alert('Your comment was susscessfull added'); window.close()</script>");		
	}	
}

function reportClip()
{
	var id = intval(Request.QueryString("cid"));
	if(!user["id"])
	{
		Response.Write("<script>alert('You are not login'); window.close()</script>");
	}
	else
	{
		var query = "insert into mc_report (clip_id, user_id, comment) values("+id+","+user["id"]+", 'Please check this clip!')";
		conn.Execute(query);
		Response.Write("<script>alert('This clip was reported as broken'); window.close()</script>");
	}
	
	
}


var dorequest = Request.QueryString("do");

if(dorequest == "view")
{
	viewClip();
}
else if(dorequest == "rate")
{
	rateClip();
}
else if(dorequest == "comment")
{
	commentClip();
}
else if(dorequest == "report")
{
	reportClip();
}
else
{
	
}

%>