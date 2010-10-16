<%

var doaction = new String (Request.QueryString("do")).toString();

function showSugguestion()
{

	redirect(10, "default.asp?act=channel");
%>
		
<%
}


if(doaction == "show")
{
	showSugguestion();
}


%>
