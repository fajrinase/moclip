<%

function showTopRate()
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
		
		var query = "SELECT top 9 mc_channel.title as ctitle, mc_channel.cid as cid , c.title, c.description , c.id, c.image, mc_users.uid, username, fullname";
		query += " FROM mc_clips as c";
		query += " INNER JOIN mc_channel  ON mc_channel.cid = c.chanel_id cross JOIN mc_users ";
		query += "order by floor(( select sum(rate) from mc_clip_rate where clip_id= c.id) / ( select COUNT(*) from mc_clip_rate where clip_id= c.id)) DESC"

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
				var title = trim(new String(rs("title")).toString());
				var desc = trim(new String(rs("description")).toString());
				var submiter = trim(new String(rs("username")).toString());
				var channel = trim(new String(rs("ctitle")).toString());
				var id = intval(new String(rs("id")));
				var uid = intval(new String(rs("uid")));
				var cid = intval(new String(rs("cid")));
				
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
		rs.Open("SELECT top 9 c.id, c.title, c.image,c.description FROM mc_clips as c order by hits DESC", conn);
		
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
		rs.Open("select title, id, image, description from mc_clips where chanel_id='"+intval(cid)+"' order by id DESC", conn);
		
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
		rs.Open("select top 9 title, id, image, description from mc_clips order by  NEWID() ", conn);
		
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
		rs.Open("SELECT top 9 c.id, c.title, c.image,c.description FROM mc_clips as c order by id DESC", conn);
		
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

function listAll()
{
	rs = Server.CreateObject("ADODB.Recordset");

	rs.Open("SELECT cid, title, total_clips  FROM mc_channel ORDER BY title ASC", conn);
	
	var total = rs("cid").count;
	
	Response.Write(total);
	
	while(! rs.EOF)
	{
		Response.Write("<div class='cat-list-item'>");
		Response.Write("<div class='cat-item-title'>" + rs("title") + "("+rs("total_clips")+" clips)</div>");
		
		var subrs = Server.CreateObject("ADODB.Recordset");
		subrs.Open("select top 4 c.id, c.title, c.image FROM mc_clips as c where c.chanel_id="+rs("cid")+" order by c.date_added DESC", conn);
		
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