<%

var myaction = Request.QueryString("do");

if(myaction == "view")
{
	viewDetails();
}
else {
	listNews();
}


function listNews()
{
	var current_page		= 1;
	var perpage 			= 5;	
	rs = Server.CreateObject("ADODB.Recordset");
	rs.CursorLocation = 3; 
	rs.PageSize       = perpage; 
	rs.CacheSize      = perpage;
	
	if(isset(Request.QueryString("page")) && Request.QueryString("page") != "")
	{
		current_page = (intval(Request.QueryString("page")) > 0) ? intval(Request.QueryString("page")) : 1;
	}
	
	rs.Open("SELECT nid, title, date_added, description, fullname, image FROM mc_news inner join mc_users on(uid = submiter) ORDER BY nid DESC", conn);
	var total = rs.PageCount;
	var pageslink = build_page(total, perpage , current_page, "default.asp?act=news");
	
	if(total == 0)
	{
		Response.Write("No news found!");
	}
	else
	{
		rs.AbsolutePage = current_page;
		
		Response.Write("<ul>");
		
		var i = 0;
		while (rs.AbsolutePage == current_page && ! rs.EOF)
		{
			if(i == 0)
			{
				%>
					<li>
						<div class="news-first-artical">
							<div class="news-fisrt-image"><img id="news-<%=rs("nid")%>" src="<%=rs("image")%>" alt="" title="" onload="resize('news-<%=rs("nid")%>', 300)"/></div>
							<div class="news-fisrt-title"><a href="default.asp?act=news&do=view&nid=<%=rs("nid")%>" alt="" title=""><%=rs("title")%></a></div>
							
							<div class="news-fisrt-orther">On <%=rs("date_added")%></div>
							<div class="news-fisrt-orther">Post by: <%=rs("fullname")%></div>
							<div class="news-fisrt-desc"><%=rs("description")%></div>
							<div></div>
						</div>
					</li>
					<li class="clear"></li>
				<%
			}
			else
			{
				%>
					<li class="more-news-list">
						<div class="news-more-image"><img id="news-<%=rs("nid")%>" src="<%=rs("image")%>" alt="" title="" onload="resize('news-<%=rs("nid")%>', 100)"/></div>
						<div class="news-more-title"><a href="default.asp?act=news&do=view&nid=<%=rs("nid")%>" alt="" title=""><%=rs("title")%></a></div>
					
						<div class="news-more-orther">On <%=rs("date_added")%></div>
						<div class="news-more-orther">Post by: <%=rs("fullname")%></div>
						<div class="news-more-desc"><%=rs("description")%></div>
						<div></div>
					</li>
					
				<%
				if((i % 2) == 0) {
					Response.Write("<li class='clear'></li>")
				}
			}			
			i++;
			rs.MoveNext;
		}
		
		Response.Write("<li class='clear'></li></ul>");
		
		rs.Close();
		rs = null;
	}	
}

function viewDetails()
{
	nid = intval(Request.QueryString("nid")) 
	rs = Server.CreateObject("ADODB.Recordset");
	
	rs.Open("SELECT nid, title, date_added, description, content, fullname, image FROM mc_news inner join mc_users on(uid = submiter) where nid="+nid, conn);
	
	if(!rs.EOF)
	{
		rs.MoveFirst;
		
		title = trim(rs("title"));
		content = trim(rs("content"));
		date_added = trim(rs("date_added"));
		image =  trim(rs("image"));;
		description = trim(rs("description"));;
		nid = intval(rs("nid"));
		%>
			<div class="news-fisrt-title"><a href="default.asp?act=news&do=view&nid=<%=rs("nid")%>" alt="" title=""><%=rs("title")%></a></div>
			<div class="news-fisrt-orther">On <%=rs("date_added")%></div>
			<div class="news-fisrt-orther">Post by: <%=rs("fullname")%></div>
			<div class="news-fisrt-desc"><%=rs("description")%></div>
			
			<div class="news-more-content"><%=rs("content")%></div>
		<%
	}
}


%>