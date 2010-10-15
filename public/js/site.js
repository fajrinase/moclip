// JavaScript Document

function getFileExtension(fname) {

	var pos = fname.lastIndexOf(".");

	var strlen = fname.length;

	if (pos != -1 && strlen != pos + 1) {

		var ext = fname.split(".");

		var len = ext.length;

		var extension = ext[len - 1].toLowerCase();

	} else {

		extension = "undefined";

	}

	return extension;
}

toggleContent = function(obj) {
	obj.oldtext = obj.value;
	obj.value = "";

	obj.onblur = function() {
		
		if (this.value == "") {
			if(obj.defaultValue != "")
			{
				this.value = this.defaultValue;
			}
			else {
				this.value = this.name;	
			}			
		}
	}

}

/**
 * rating
 */
loadRatingModule = function(option)
{
	if(typeof(option) == "object")
	{
		this.el = $(option.id);		
	}
	else
	{
		return false;		
	}
	
	this.initComponent = function(runtime)
	{
		clearTimeout(this.timeout);
		if(runtime)
		{			
			this.timeout = setInterval(this.initRender.bind(this, 0), runtime);
		}
	}
	
	this.initRender = function(fill)
	{		
		this.el.innerHTML = "";
		//now render a rating element
		var mf = (fill > 0) ? fill : option.rated;
		for(var i = 1; i < 6; i++)
		{
			//so now i have to get sorce
			var img = document.createElement('img');
			img.setAttribute("id", "start-"+i+"-"+option.cid);
			if(i <= mf)
			{
				img.setAttribute("src", "public/images/star.gif");
			}
			else
			{
				img.setAttribute("src", "public/images/0-star.gif");
			}
			
			this.el.appendChild(img);
			if(option.allowRate == 1)
			{
				$(img.id).addEvent('mousedown', this.setRating.bind(this, i));
				$(img.id).addEvent("mouseout", this.initComponent.bind(this, 500));
				$(img.id).addEvent('mouseover', this.fillRate.bind(this, {idx : i, runtime : 50}));
			}
			
			if(option.allowRate == 0)
			{
				$(img.id).addEvent('mousedown', function() {
					alert("Please login before do it!");
				});
			}
			
		}
		
		return false;
		
	}
	
	this.fillRate = function(obj) {
		clearTimeout(this.timeout);
		if(obj.runtime)
		{			
			this.timeout = setInterval(this.initRender.bind(this, obj.idx), obj.runtime);
		}
				
		return false;
	}
	
	this.setRating = function(point) {
		mypopuppopuot("popup.asp?act=clip&do=rate&cid="+option.cid+"&p="+point, "mywindow_"+option.cid);		
	}
	
	this.initRender(0);
}

function mypopuppopuot(url, name)
{
   	var mywindow = window.open (url, name, "location=0,status=0,scrollbars=0,width=10,height=10");
   	try {
   		mywindow.moveTo(200,200);
   		//mywindow.close();
   	}
   	catch(e) { alert("Please allow Popup!") }; 	
  	
} 

postaComment = function()
{
	var content = $("comment-content");
	var title = $("comment-title");
	var cid = $("comment-cid");
	
	if(title.value.length < 4 || title.value == "Title") {
		alert("Title is to short!");
		title.focus();
		return false;
	}
	
	if(content.value.length < 10) {
		alert("Comment is to short!");
		content.focus();
		return false;
	}
	
	mypopuppopuot("popup.asp?act=clip&do=comment&cid="+cid.value+"&content="+content.value+"&title="+title.value, "mywindow_"+cid.value);
	
}

reportThisClip = function(cid)
{
	var cfm = window.confirm("Are you sure report this clip as broken?");
	if(cfm)
	{
		mypopuppopuot("popup.asp?act=clip&do=report&cid="+cid, "mywindow_"+cid);
	}	
}
