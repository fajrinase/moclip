<%

function showTopRate()
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
		
		if(mysql) {
			var query = "SELECT mc_channel.title as ctitle, c.hits, c.chanel_id as cid , c.title, c.description , c.id, c.image, c.submiter as uid, u.username, u.fullname, t_rate.rate_percent, t_rate.rate_total";
			query += " FROM mc_clips as c ";
			query += " INNER JOIN mc_channel ON mc_channel.cid = c.chanel_id ";
			query += " inner JOIN mc_users as u ON(u.uid = c.submiter)";
			query += " left join (select clip_id, count(rate) as rate_total, AVG(rate) as rate_percent from mc_clip_rate group by clip_id) as t_rate on(t_rate.clip_id = c.id)";
			query += " where c.approve=1";
			query += " order by rate_percent desc limit 10"
		}
		else {
			var query = "SELECT top 10 mc_channel.title as ctitle, c.hits, c.chanel_id as cid , c.title, c.description , c.id, c.image, c.submiter as uid, u.username, u.fullname, t_rate.rate_percent, t_rate.rate_total";
			query += " FROM mc_clips as c ";
			query += " INNER JOIN mc_channel ON mc_channel.cid = c.chanel_id ";
			query += " inner JOIN mc_users as u ON(u.uid = c.submiter)";
			query += " left join (select clip_id, count(rate) as rate_total, AVG(rate) as rate_percent from mc_clip_rate group by clip_id) as t_rate on(t_rate.clip_id = c.id)";
			query += " where c.approve=1";
			query += " order by rate_percent desc"
		}		

		rs.Open(query, conn);
				
		var total = rs.PageCount;
		var pageslink = build_page(total, perpage , current_page, "default.asp?act=channel");
				
		if(total == 0)
		{
			Response.Write("No CLips");
		}
		else
		{
			var i = 0;
			rs.AbsolutePage = current_page;
			Response.Write("<ul class='list-clips'>");
			while (rs.AbsolutePage == current_page && ! rs.EOF)
			{
				var image = trim(new String(rs("image")).toString());
				var ctitle = trim(new String(rs("ctitle")).toString());
				var title = trim(rs("title"));
				var desc = trim(new String(rs("description")).toString());
				var submiter = trim(new String(rs("username")).toString());
				var channel = trim(new String(rs("ctitle")).toString());
				var id = intval(new String(rs("id")));
				hits = intval(new String(rs("hits")));
				var uid = intval(new String(rs("uid")));
				var cid = intval(new String(rs("cid")));
				rate = intval(new String(rs("rate_percent")));
				rate_total = intval(new String(rs("rate_total")));
				
				if(i == 0)
				{
					%>
					
					<li class="clip-row-first"> 
						<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
							<div class='clip-image'><img src="image.asp?f=<%=image%>&w=670&h=250" alt="<%=title%>"/></div>
							<div class='clip-title'>
								<span><%=title%></span>
								<div class='clip-desc'><%=desc%></div>
							</div>							
						</a>										
					</li>
					
					<%
				}
				else
				{
					%>
						<li class="column-channel-news">
					<div><a href="default.asp?act=channel&id=<%=cid%>" alt="<%=ctitle%>"><%=ctitle%></a></div>
					<div class="column-channel-news-image"><a href="default.asp?act=clip&do=view&id=<%=id%>" alt="<%=title%>"><img src="image.asp?f=<%=image%>&w=180&h=150" alt="<%=title%>"/></a></div>
					<div><a href="default.asp?act=clip&do=view&id=<%=id%>" alt="<%=title%>"><%=title%></a></div>
					<!--<div class="column-channel-news-description"><%=desc%></div>-->
					<div id="clip-start-rate-<%=id%>"></div>					
					<script type="text/javascript">
						new loadRatingModule({ id : "clip-start-rate-<%=id%>", rated : <%=rate%>, total : <%=rate_total%>, cid : <%=cid%>, allowRate : 2 });
					</script>
					<div>Hits <b><%=hits%></b></div>
				</li>
						
					<%
				}
				
				if(i++%3==0) 
				{
					Response.Write("<li class='clip-column'></li>");
				}
				
				rs.MoveNext;
			}
			Response.Write("<li class='clip-column'></li>");
			Response.Write("</ul>");
		}

		rs.Close();
		rs = null;
}


function showTopView()
{
	//Build query string
		var current_page		= 1;
		var perpage 			= 9;
		if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
		{
			current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
		}
		
		rs = Server.CreateObject("ADODB.Recordset");
		rs.CursorLocation = 3; 
		rs.PageSize       = perpage; 
		rs.CacheSize      = perpage;
		if(mysql) {
		rs.Open("SELECT c.id, c.title, c.image,c.description FROM mc_clips as c where c.approve=1 order by hits DESC limit 9", conn);
		}
		else
		rs.Open("SELECT top 9 c.id, c.title, c.image,c.description FROM mc_clips as c where c.approve=1 order by hits DESC", conn);
		
		var total = rs.PageCount;
		var pageslink = build_page(total, perpage , current_page, "default.asp?act=channel");
				
		if(total == 0)
		{
			Response.Write("No CLips");
		}
		else
		{
			var i = 0;
			rs.AbsolutePage = current_page;
			Response.Write("<ul class='list-clips'>");
			while (rs.AbsolutePage == current_page && ! rs.EOF)
			{
				var image = trim(new String(rs("image")).toString());
				var title = trim(new String(rs("title")).toString());
				var desc = trim(new String(rs("description")).toString());
				var id = intval(new String(rs("id")));
				
				if(i == 0)
				{
					%>
					
					<li class="clip-row-first"> 
						<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
							<div class='clip-image'><img src="image.asp?f=<%=image%>&w=670&h=250" alt="<%=title%>"/></div>
							<div class='clip-title'><span><%=title%></span>
								<div class='clip-desc'><%=desc%></div>
							</div>
						</a>						
					</li>
					
					<%
				}
				else
				{
					%>
						<li class="clip-row">
							<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
								<div class='clip-image'><img src="image.asp?f=<%=image%>&w=150&h=250" alt="<%=title%>"/></div>
								<div class='clip-title'><span><%=title%></span></div>
							</a>					
						</li>
						
					<%
				}
				
				if(i++%4==0) 
				{
					Response.Write("<li class='clip-column'></li>");
				}
				
				rs.MoveNext;
			}
			Response.Write("<li class='clip-column'></li>");
			Response.Write("</ul>");
		}

		rs.Close();
		rs = null;
}

function showChannel()
{
	cid = Request.QueryString("id");
	if( cid > 0)
	{
		//Build query string
		var current_page		= 1;
		var perpage 			= 9;
		if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
		{
			current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
		}
		
		rs = Server.CreateObject("ADODB.Recordset");
		rs.CursorLocation = 3; 
		rs.PageSize       = perpage; 
		rs.CacheSize      = perpage;
		rs.Open("select title, id, image, description from mc_clips where chanel_id='"+intval(cid)+"' and approve=1 order by id DESC", conn);
		
		var total = rs.PageCount;
		var pageslink = build_page(total, perpage , current_page, "default.asp?act=channel&id="+intval(cid));
				
		if(total == 0)
		{
			Response.Write("No CLips");
		}
		else
		{
			var i = 0;
			rs.AbsolutePage = current_page;
			Response.Write("<ul class='list-clips'>");
			while (rs.AbsolutePage == current_page && ! rs.EOF)
			{
				var image = trim(new String(rs("image")).toString());
				var title = trim(new String(rs("title")).toString());
				var desc = trim(new String(rs("description")).toString());
				var id = intval(new String(rs("id")));
				
				if(i == 0)
				{
					%>
					
					<li class="clip-row-first"> 
						<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
							<div class='clip-image'><img src="image.asp?f=<%=image%>&w=670&h=250" alt="<%=title%>"/></div>
							<div class='clip-title'><span><%=title%></span>
								<div class='clip-desc'><%=desc%></div>
							</div>
						</a>						
					</li>
					
					<%
				}
				else
				{
					%>
						<li class="clip-row">
							<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
								<div class='clip-image'><img src="image.asp?f=<%=image%>&w=150&h=250" alt="<%=title%>"/></div>
								<div class='clip-title'><span><%=title%></span></div>
							</a>					
						</li>
						
					<%
				}
				
				if(i++%4==0) 
				{
					Response.Write("<li class='clip-column'></li>");
				}
				
				rs.MoveNext;
			}
			Response.Write("<li class='clip-column'></li>");
			Response.Write("</ul>");
			if(pageslink != "")
			{
				Response.Write("<div style='text-align:right;margin:5px;'>"+pageslink+"</div>\n");
			}
		}

		rs.Close();
		rs = null;
		
	}
	/*************************************************
	* List by default
	*/
	else
	{
		//Build query string
		var current_page		= 1;
		var perpage 			= 9;
		if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
		{
			current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
		}
		
		rs = Server.CreateObject("ADODB.Recordset");
		rs.CursorLocation = 3; 
		rs.PageSize       = perpage; 
		rs.CacheSize      = perpage;
		if(mysql)
		rs.Open("select title, id, image, description from mc_clips where approve=1 order by  rand() limit 9", conn);
		else
		rs.Open("select top 9 title, id, image, description from mc_clips where approve=1 order by  NEWID() ", conn);
		
		var total = rs.PageCount;
		var pageslink = build_page(total, perpage , current_page, "default.asp?act=channel");
				
		if(total == 0)
		{
			Response.Write("No CLips");
		}
		else
		{
			var i = 0;
			rs.AbsolutePage = current_page;
			Response.Write("<ul class='list-clips'>");
			while (rs.AbsolutePage == current_page && ! rs.EOF)
			{
				var image = trim(new String(rs("image")).toString());
				var title = trim(new String(rs("title")).toString());
				var desc = trim(new String(rs("description")).toString());
				var id = intval(new String(rs("id")));
				
				if(i == 0)
				{
					%>
					
					<li class="clip-row-first"> 
						<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
							<div class='clip-image'><img src="image.asp?f=<%=image%>&w=670&h=250" alt="<%=title%>"/></div>
							<div class='clip-title'><span><%=title%></span>
								<div class='clip-desc'><%=desc%></div>
							</div>
						</a>						
					</li>
					
					<%
				}
				else
				{
					%>
						<li class="clip-row">
							<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
								<div class='clip-image'><img src="image.asp?f=<%=image%>&w=150&h=250" alt="<%=title%>"/></div>
								<div class='clip-title'><span><%=title%></span></div>
							</a>					
						</li>
						
					<%
				}
				
				if(i++%4==0) 
				{
					Response.Write("<li class='clip-column'></li>");
				}
				
				rs.MoveNext;
			}
			Response.Write("<li class='clip-column'></li>");
			Response.Write("</ul>");
		}

		rs.Close();
		rs = null;
		
	}
}

function showJustAdded()
{
	//Build query string
		var current_page		= 1;
		var perpage 			= 9;
		if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
		{
			current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
		}
		
		rs = Server.CreateObject("ADODB.Recordset");
		rs.CursorLocation = 3; 
		rs.PageSize       = perpage; 
		rs.CacheSize      = perpage;
		if(mysql)
		rs.Open("SELECT c.id, c.title, c.image,c.description FROM mc_clips where approve=1 as c order by id DESC limit 9", conn);
		else
		rs.Open("SELECT top 9 c.id, c.title, c.image,c.description FROM mc_clips as c where approve=1 order by id DESC", conn);
		
		var total = rs.PageCount;
		var pageslink = build_page(total, perpage , current_page, "default.asp?act=channel&do=justadd");
				
		if(total == 0)
		{
			Response.Write("No CLips");
		}
		else
		{
			var i = 0;
			rs.AbsolutePage = current_page;
			Response.Write("<ul class='list-clips'>");
			while (rs.AbsolutePage == current_page && ! rs.EOF)
			{
				var image = trim(new String(rs("image")).toString());
				var title = trim(new String(rs("title")).toString());
				var desc = trim(new String(rs("description")).toString());
				var id = intval(new String(rs("id")));
				
				if(i == 0)
				{
					%>
					
					<li class="clip-row-first"> 
						<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
							<div class='clip-image'><img src="image.asp?f=<%=image%>&w=670&h=250" alt="<%=title%>"/></div>
							<div class='clip-title'><span><%=title%></span>
								<div class='clip-desc'><%=desc%></div>
							</div>
						</a>						
					</li>
					
					<%
				}
				else
				{
					%>
						<li class="clip-row">
							<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
								<div class='clip-image'><img src="image.asp?f=<%=image%>&w=150&h=250" alt="<%=title%>"/></div>
								<div class='clip-title'><span><%=title%></span></div>
							</a>					
						</li>
						
					<%
				}
				
				if(i++%4==0) 
				{
					Response.Write("<li class='clip-column'></li>");
				}
				
				rs.MoveNext;
			}
			Response.Write("<li class='clip-column'></li>");
			Response.Write("</ul>");
		}

		rs.Close();
		rs = null;
}

function listAll()
{
	rs = Server.CreateObject("ADODB.Recordset");

	rs.Open("SELECT cid, title, total_clips  FROM mc_channel ORDER BY title ASC", conn);
	
	var total = rs("cid").count;
			
	while(! rs.EOF)
	{
		Response.Write("<div class='cat-list-item'>");
		Response.Write("<div class='cat-item-title'><a href='default.asp?act=channel&id="+rs("cid")+"'>" + rs("title") + "("+rs("total_clips")+" clips)</div>");
		
		var subrs = Server.CreateObject("ADODB.Recordset");
		if(mysql)
		subrs.Open("select c.id, c.title, c.image FROM mc_clips as c where c.chanel_id="+rs("cid")+" and c.approve=1 order by c.date_added DESC limit 4", conn);
		else
		subrs.Open("select top 4 c.id, c.title, c.image FROM mc_clips as c where c.chanel_id="+rs("cid")+" and c.approve=1 order by c.date_added DESC", conn);
		
		Response.Write("<ul class='list-clips'>");
		
		while(! subrs.EOF)
		{
			var image = trim(new String(subrs("image")).toString());
			var title = trim(new String(subrs("title")).toString());
			var id = intval(new String(subrs("id")));
			
			%>
				<li class="clip-row">
					<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
						<div class='clip-image'><img src="image.asp?f=<%=image%>&w=150&h=250" alt="<%=title%>"/></div>
						<div class='clip-title'><span><%=title%></span></div>
					</a>					
				</li>
				
			<%
			subrs.MoveNext;
		}	
		Response.Write("<li class='clip-column'></li>");
		Response.Write("</ul>");	
		
		subrs.Close();
		subrs = null;	
		
		Response.Write("</div>");
		rs.MoveNext;
	}
	
	rs.Close();
	rs = null;	
}

var dorequest = Request.QueryString("do");

if(dorequest == "toprate")
{
	showTopRate();
}
else if(dorequest == "tophit")
{
	showTopView();
}
else if(dorequest == "justadd")
{
	showJustAdded();
}
else if(dorequest == "all")
{
	listAll();
}
else
{
	showChannel();
}



%>