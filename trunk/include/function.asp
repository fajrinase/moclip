<%
function trim_text(stringtext)
{
	return stringtext.replace(/^([ \t]|\n|\&nbsp;|<!--[^-]+-->)*/, "").replace(/([ \t]|\n|\&nbsp;|<!--[^-]+-->)*$/, "");
}

function ltrim(str) 
{ 
    return str.replace(/^[ ]+/, ''); 
} 
 
function rtrim(str) 
{ 
    return str.replace(/[ ]+$/, ''); 
} 
 
function trim(str) 
{ 
	if(!isset(str))
		return "";
	else {
		return ltrim(rtrim(new String(str))); 
	}    
} 


function intval(s)
{
	s = parseInt(s);
	s = isNaN(s) ? 0 : s;
	return ((s <= 0 ) ? 0 : s);
}

function redirect(text, url)
{
	try
	{
		rs.Close();
		rs = null;
		conn.Close();
		conn = null;
	}
	catch(e) {}
	Response.Redirect(config["site_url"] + "/" + ((is_admin_page == 1 ) ? "admin/" : "" ) + "redirect.asp?id=" + text + "&url=" + Server.URLEncode(url));
}

function isset(obj)
{
	var sTypeof = typeof(obj);

	if(sTypeof == "undefined" || String(obj).valueOf() == "undefined")
	{
		return false;
	}
	else
	{
		return true;
	}
}

function show_error(code)
{
	try
	{
		rs.Close();
		rs = null;
		conn.Close();
		conn = null;
	}
	catch(e) {}
	Response.Redirect(config["site_url"] + "/?error=" + code);
}

function safe_query(s)
{
	s = new String(s);
	//s = s.replace('/"/', "&quot;");
	//s = s.replace("/'/", "&#39;");
	//str = str.replace(/&amp;/g,"&");
	//str = str.replace(/&lt;/g,"<");
	//str =  str.replace(/&gt;/g,">");

	s = s.replace(new RegExp("'", "g"), "&#39;");	
	//s = s.replace(new RegExp('"', "g"), "&quot;");
	return s;
}

function truncate(text, len )
{
	return (text.length > len ? text.slice(0, len - 3) + '...' : text);
}

function build_page(total, perpage, current, url)
{
	var preg    = /\.asp$/i;
	var page = total;
	var upper 	= current * perpage;
	var lower 	= upper - perpage;
	
	current = (current > total) ? page : current;
	current = (current <= 0 ) ? 1 : current;
	
	if(preg.test(url))
	{
		url += "?page=";
	}
	else
	{
		url += "&amp;page=";
	}

	if(page <= 1)
	{
		return "";
	}
	else
	{
		if(current > 1)
		{
			first  		= "<a href='"+url+"1'>First</a>&nbsp;|";
			previous 	= "&nbsp;<&nbsp;<a href='"+url+parseInt(current-1)+"'>Previous</a>";
		}
		else
		{
			first 		= "First&nbsp;|";
			previous	=	"&nbsp;<&nbsp;Previous";		
			
			if ( 1 < (current - 2))
			{
				first  		= "<a href='"+url+"1'>First</a>";
			}		
		}
		
		if(current < page)
		{
			last  = "|&nbsp;<a href='"+url+page+"'>Last</a>&nbsp;";
			next 	= "&nbsp;|&nbsp;<a href='"+url+parseInt(current+1)+"'>Next</a>&nbsp;>&nbsp;";
		}	
		else
		{
			last  = "|&nbsp;Last";
			next 	= "&nbsp;|&nbsp;Next&nbsp;>&nbsp;";
		}
		var page_span = "";
		for( var i=1; i<= page; i++ )
		{
			var PageNo = i;
			
			if (PageNo == current)
			{
				page_span +=  "&nbsp;<span style='background-color:#c6c6c6;padding: 0 2px;'>"+PageNo+"</span>&nbsp;";
			}
			else
			{
				if (PageNo < (current - 2))
				{
					continue;
				}
				if (PageNo > (current + 2 ))
				{
					break;
				}
				page_span+= "&nbsp;<a href='"+url+PageNo+"'>"+PageNo+"</a>&nbsp;";
			}
		}
		return page_span+first+previous+next+last;
	}
	
}

function in_array(needle, haystack)
{
	for(var i in haystack)
	{
        if(haystack[i] === needle)
		{
			return true;
		}
  }

	return false;
}

function unlink(path)
{

	if(path)
	{
		var fs = Server.CreateObject("Scripting.FileSystemObject");

		if(fs.FileExists(path))
		{
			try
			{
				fs.DeleteFile(path);
			}
			catch(e)
			{
			}
		}

		fs = null;
	}
}

function displayChannelMenu()
{
	rs = Server.CreateObject("ADODB.Recordset");

	rs.Open("SELECT cid, title, total_clips  FROM mc_channel ORDER BY title ASC", conn);
	
	while(! rs.EOF)
	{
		Response.Write("<li><a class='item' href='?act=channel&id=" + rs("cid") +"' alt='"+ rs("title")+"' ><span class='menusys_name'>" + rs("title") + "</span></a></li>" );
		rs.MoveNext;
	}
	
	rs.Close();
	rs = null;	
}

function getRandom5Clip()
{
	rs = Server.CreateObject("ADODB.Recordset");
	
	if(mysql)
	var query = "SELECT title, id, description, date_added, image  FROM mc_clips where approve=1 ORDER BY rand() limit 5";
	else
	var query = "SELECT top 5 title, id, description, date_added, image  FROM mc_clips where approve=1 ORDER BY NEWID()";

	rs.Open(query, conn);
		
	Response.Write("<ul class='list-clips slide-clip-row'>");
	
	while(!rs.EOF)
	{
		var image = trim(new String(rs("image")).toString());
		var title = trim(new String(rs("title")).toString());
		var desc = trim(new String(rs("description")).toString());
		var id = intval(new String(rs("id")));
		
		
		%>
			<li class="clip-row clip-slide-shadow">
				<a class="clip-view" href="default.asp?act=clip&do=view&id=<%=id%>" alt="">
					<div class='clip-image'><img src="image.asp?f=<%=image%>&w=165&h=250" alt="<%=title%>"/></div>
					<div class='clip-title clip-slide-title'><span><%=title%></span></div>
				</a>					
			</li>
			
		<%
		
		rs.MoveNext;
	}
	
	Response.Write("<li class='clip-column'></li>");
	Response.Write("</ul>");
	
	rs.Close();
	rs = null;
}

function getNextDay(day, resetTime){
  var days = {
    sunday: 0, monday: 1, tuesday: 2,
    wednesday: 3, thursday: 4, friday: 5, saturday: 6
  };

  var dayIndex = days[day.toLowerCase()];
  if (!dayIndex) {
    throw new Error('"' + day + '" is not a valid input.');
  }

  var returnDate = new Date();
  var returnDay = returnDate.getDay();
  if (dayIndex !== returnDay) {
    returnDate.setDate(returnDate.getDate() + (dayIndex + (7 - returnDay)) % 7);
  }

  if (resetTime) {
    returnDate.setHours(0);
    returnDate.setMinutes(0);
    returnDate.setSeconds(0);
    returnDate.setMilliseconds(0);
  }
  return returnDate;
}


%>