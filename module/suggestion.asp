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
}


if(doaction == "doPost")
{
	postwSugguestion();
}
showSugguestion();

%>
