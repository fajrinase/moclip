<%

function showTopRate()
{

}


function showTopView()
{

}

function showChannel()
{
	cid = Request.QueryString("id");
	if(typeof(cid) != "undifined")
	{
		//Build query string
		
	}
	else
	{
		//Build query string
		var query = "select top 20 title, id, image form mc_clips order by rand()"
		
	}
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