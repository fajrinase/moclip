<%

function showTopRate()
{

}


function showTopView()
{

}

function showChannel()
{
	Response.Write("Hello, i will show you all channels");
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
else
{
	showChannel();
}



%>