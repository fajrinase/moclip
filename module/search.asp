<%

function search()
{
	%>
		<script type="text/javascript" src="public/js/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js"></script>
		<link type="text/css" rel="stylesheet" media="all" href="public/js/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css" />

		<div class="view-clip-title">Search Clip</div>
		<form name="uploadClip" method="get" class="search-form" onsubmit="return searchSubmit(this)">
			<input type="hidden" name="act" value="search" />
			<input type="hidden" name="do" value="dosearch" />
			<div>
				<input type="text" name="query" value="<%=(trim(Request.QueryString("query")) != "" ? trim(Request.QueryString("query")) : "Type a text" )%>" onfocus="toggleContent(this)" defaultValue="Type a text"/>
				<input type="submit" value="Search" class="shareit" />
			</div>
			<div>
				<span>Search by</span>
				<select name="typeofsearch" style="width:183px">
					<option value="name" <%=(trim(Request.QueryString("typeofsearch")) == "name" ? "selected='seleted'" : "" )%>>By Clip name</option>
					<option value="username" <%=(trim(Request.QueryString("typeofsearch")) == "username" ? "selected='seleted'" : "" )%>>By Username</option>
					<option value="fullname" <%=(trim(Request.QueryString("typeofsearch")) == "fullname" ? "selected='seleted'" : "" )%>>By Fullname</option>
				</select>
			</div>
			
			<div>
				<span>In Channel</span>
				<select name="channel" style="width:183px">
					<option value="0">In All Channel</option>
					<%
						rs = Server.CreateObject("ADODB.Recordset");

						rs.Open("SELECT cid, title, total_clips FROM mc_channel ORDER BY title ASC", conn);
						
						var total = rs("cid").count;
						
						Response.Write(total);
						
						while(! rs.EOF)
						{
							Response.Write("<option value='" + rs("cid") +"' "+(intval(Request.QueryString("channel")) == rs("cid") ? 'selected=\'seleted\'' : '' )+">" + rs("title") + "</option>" );
							rs.MoveNext;
						}						
						rs.Close();
						rs = null;	
					%>
					
				</select>
			</div>
			<div>
				<span>From date </span>
				<input type="text" id="fromdate" name="fromdate" value="<%=(trim(Request.QueryString("query")) != "" ? trim(Request.QueryString("fromdate")) : "" )%>" style="width: 180px" onclick="displayCalendar(this,'mm/dd/yyyy',this)" />
				
			</div>
			<div>
				<span>To date </span>
				<input type="text" id="todate" name="todate" value="<%=(trim(Request.QueryString("query")) != "" ? trim(Request.QueryString("todate")) : "" )%>"style="width: 180px" onclick="displayCalendar(this,'mm/dd/yyyy',this)" />
				
			</div>
			<div>
				<span>Has rating >= </span>
				<select name="rate" style="width:183px">
					<option value="0" <%=(intval(Request.QueryString("rate")) == 0 ? "selected='seleted'" : "" )%>>0</option>
					<option value="1" <%=(intval(Request.QueryString("rate")) == 1 ? "selected='seleted'" : "" )%>>1</option>
					<option value="2" <%=(intval(Request.QueryString("rate")) == 2 ? "selected='seleted'" : "" )%>>2</option>
					<option value="3" <%=(intval(Request.QueryString("rate")) == 3 ? "selected='seleted'" : "" )%>>3</option>
					<option value="4" <%=(intval(Request.QueryString("rate")) == 4 ? "selected='seleted'" : "" )%>>4</option>
					<option value="5" <%=(intval(Request.QueryString("rate")) == 5 ? "selected='seleted'" : "" )%>>5</option>
				</select>
			</div>
		</form>
		
		<script type="text/javascript">
			searchSubmit = function(obj) {
				if(obj.query.value == "Type a text") {
					alert("Please type any keyword to search!");
					return false;
				}
				else if( obj.query.value.length < 4 ) {
					alert("Keyword to short, must longer than 4 chars!");
					return false;
				}				
			}			
		</script>
	
	<%

}

function doSearch()
{
	//Build query
	var query = "SELECT mc_channel.title as ctitle, c.hits, c.chanel_id as cid , c.title, c.description, c.date_added , c.id, c.image, c.submiter as uid, u.username, u.fullname, t_rate.rate_percent, t_rate.rate_total";
	query += " FROM mc_clips as c ";
	query += " INNER JOIN mc_channel ON mc_channel.cid = c.chanel_id ";
	query += " inner JOIN mc_users as u ON(u.uid = c.submiter)";
	query += " left join (select clip_id, count(rate) as rate_total, AVG(rate) as rate_percent from mc_clip_rate group by clip_id) as t_rate on(t_rate.clip_id = c.id)";
	query += " where c.approve=1";
	
	//Filter
	if(trim(Request.QueryString("query")) != "" && trim(Request.QueryString("typeofsearch")) == "fullname" ) {
		query += " and u.fullname like ('"+trim(Request.QueryString("query"))+"%')";
	}	
	else if(trim(Request.QueryString("query")) != "" && trim(Request.QueryString("typeofsearch")) == "username" ) {
		query += " and u.username like ('"+trim(Request.QueryString("query"))+"%')";
	}
	else {
		query += " and c.title like ('"+trim(Request.QueryString("query"))+"%')";
	}
	if(intval(Request.QueryString("channel")) > 0) {
		query += " and cid="+intval(Request.QueryString("channel"))
	}
	if(trim(Request.QueryString("fromdate")) != "") {
		if(trim(Request.QueryString("todate")) != "") {
			query += " and c.date_added between '"+trim(Request.QueryString("fromdate"))+"' and '"+trim(Request.QueryString("todate"))+"'";
		}
		else {
			query += " and c.date_added between '"+trim(Request.QueryString("fromdate"))+"' and GETDATE()";
		}		
	}
	if(intval(Request.QueryString("rate")) > 0) {
		query += " and t_rate.rate_percent >="+intval(Request.QueryString("rate"))
	}
	
	query += " order by NEWID()";
	
	//other stuff	
	var current_page		= 1;
	var perpage 			= 18;
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
	var pageslink = build_page(total, perpage , current_page, "default.asp?act=channel");
	
	%>
		<div class="view-clip-title">Search result:</div>
	<%
			
	if(total == 0)
	{
		Response.Write("No CLips found!");
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
				
%>
<li class="column-search-row">
	<!--<div><a href="default.asp?act=channel&id=<%=cid%>" alt="<%=ctitle%>"><%=ctitle%></a></div>-->
	<div class="column-channel-news-image">
		<a href="default.asp?act=clip&do=view&id=<%=id%>" alt="<%=title%>">
			<img src="image.asp?f=<%=image%>&w=180&h=150" alt="<%=title%>"/>
		</a>
	</div>
	<div><a href="default.asp?act=clip&do=view&id=<%=id%>" alt="<%=title%>"><%=title%></a></div>
	<div><%=rs("date_added")%></div>
	<!--<div class="column-channel-news-description"><%=desc%></div>-->
	<div id="clip-start-rate-<%=id%>"></div>					
	<script type="text/javascript">
		new loadRatingModule({ id : "clip-start-rate-<%=id%>", rated : <%=rate%>, total : <%=rate_total%>, cid : <%=cid%>, allowRate : 2 });
	</script>
	<div>Hits <b><%=hits%></b></div>
</li>	
<%				
			i++;				
			if(i > 0 && i%3==0) 
			{				
				Response.Write("<li class='clip-column'></li>");
			}
			
			rs.MoveNext;
		}
		
		Response.Write("<li class='clip-column'></li>");
		Response.Write("</ul>");
		
		if(trim(Request.QueryString("query")) != "")  {
		    if(trim(Request.Cookies("query")) != "") {
				var keywords =  trim(Request.Cookies("query")).split(",");
				var newArray = new Array();
				var added = false;
				for(var j = keywords.length - 1; ; j--) {					
					if(j < 0 || j < keywords.length - 5) break;					
					var key = keywords[j].split(":");
										
					if(trim(Request.QueryString("query")) == key[0]) {
						key[1] = i;
						key[2] = intval(key[2]) + 1;
						added = true;
					}
					newArray.push(key[0]+":"+key[1]+":"+key[2]);
				}
				if(added == false) {
					newArray.push(trim(Request.QueryString("query"))+":"+i+":1");
				}				
				Response.Cookies("query") = newArray.toString();
				Response.Cookies("query").Expires="May 10,2012";
			}
			else {
				Response.Cookies("query") = trim(Request.QueryString("query"))+":"+i+":1";
				Response.Cookies("query").Expires="May 10,2012";
			}			
		}		
	}

	rs.Close();
	rs = null;
	
	
	
}


var dorequest = Request.QueryString("do");

search();

if(dorequest == "dosearch")
{
	doSearch();
}
else
{
	Response.Write(Request.Cookies("query"));
}
%>