<%

function search()
{
	%>
		<script type="text/javascript" src="public/js/dhtmlgoodies_calendar/dhtmlgoodies_calendar.js"></script>
		<link type="text/css" rel="stylesheet" media="all" href="public/js/dhtmlgoodies_calendar/dhtmlgoodies_calendar.css" />

		<div>Search Clip</div>
		<form name="uploadClip" method="get" action="default.asp?act=search&do=dosearch" class="search-form">
			<div>
				<input type="text" name="query" value="Type a text" onfocus="toggleContent(this)" defaultValue="Type a text"/>
				search by
				<select name="typeofsearch" style="width:100px">
					<option value="name" selected="selected">By Clip name</option>
					<option value="username">By Username</option>
					<option value="fullname">By Fullname</option>
				</select>
				
			</div>
			
			<div>
				<span>in Channel</span>
				<select name="channel" style="width:120px">
					<option value="0" selected="selected">In All Channel</option>
					<%
						rs = Server.CreateObject("ADODB.Recordset");

						rs.Open("SELECT cid, title, total_clips  FROM mc_channel ORDER BY title ASC", conn);
						
						var total = rs("cid").count;
						
						Response.Write(total);
						
						while(! rs.EOF)
						{
							Response.Write("<option value='" + rs("cid") +"'>" + rs("title") + "</option>" );
							rs.MoveNext;
						}
						
						rs.Close();
						rs = null;	
					%>
					
				</select>
			</div>
			<div>
				<span>From date </span>
				<input type="text" id="fromdate" name="fromdate" value="" style="width: 118px" onclick="displayCalendar(document.forms[0].fromdate,'mm/dd/yyyy',this)" />
				
			</div>
			<div>
				<span>To date </span>
				<input type="text" id="todate" name="todate" value=""style="width: 118px" onclick="displayCalendar(document.forms[0].todate,'mm/dd/yyyy',this)" />
				
			</div>
			<div>
				<span>Has rating langer than </span>
				<select name="rate" style="width:120px">
					<option value="0">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
				</select>
			</div>
		</form>
		
		<script type="text/javascript">
			
			 window.addEvent('domready', function() { 
			 	
			});
		</script>
	
	<%

}

function doSearch()
{

}


var dorequest = Request.QueryString("do");

if(dorequest == "dosearch")
{
	doSearch();
}
else
{
	search();	
}
%>