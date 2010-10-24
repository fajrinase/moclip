<%
var doaction = new String (Request.QueryString("do")).toString();

function showSugguestion()
{
%>
<div class="view-clip-title">Make a Suggestion</div>

MoClip! was started for YOU, so if you have suggestions or feedback on how we can improve, please let us know. If you want to see a specific topic covered, answer to a specific MoClip! question, or anything else of this sort, don't hesitate to ask just let us know. We do our best to keep up!	

<div class="view-clip-title">For Questions</div>
For questions please be as detailed and thorough as you can, so we can do a write up on our site, and answer your question completely. Not all questions will be answered on this site. If the question is more personal, then we will deal with it through email.	

<%
	if(user["id"])
	{
%>
<div>
<div class="view-clip-title">Post your Question</div>
<form name="uploadClip" class="search-form" action="default.asp?act=suggestion&do=doPost" method="POST" onSubmit="return checkform(this)">
	<div>Title:</div>
	<div>
		<input type="text" name="title" value="Enter title" defaultValue="Enter title" onfocus="toggleContent(this)" />
	</div>
	<div>Content</div>
	<div>
		<textarea name="content"></textarea>	
	</div>
	<div style="">
		<input type="submit" value="Post" class="shareit" />
	</div>
</form>
<script type="text/javascript">
	function checkform(o) {
		if(o.title.value.length < 4 || o.title.value == "Enter title") {
			alert("Title is short! must min 4 chars.");
			o.title.focus();
			return false;
		}
		
		if(o.content.value.length < 4 ) {
			alert("Content is short! must min 4 chars.");
			o.content.focus();
			return false;
		}
	}
</script>
</div>
<%
	}
}


if(doaction == "doPost")
{
	postSugguestion();
}
else
	showSugguestion();

function postSugguestion()
{
	Response.Write(user["id"] ? "asdsa" : "lol");
	if(user["id"] > 0) 
	{
		var title = safe_query(Request.Form("title"));
		var content = safe_query(Request.Form("content"));
		
		conn.Execute("insert into mc_suggestion (user_id, content, title, date_added) values ("+user["id"]+", '"+content+"', '"+title+"', '"+now+"')");
		
		redirect(30, "default.asp?act=suggestion");	
	
	}
	else
	{
		Response.Write(user["id"]);
		Response.Write("Please login first");
	}
}

%>
