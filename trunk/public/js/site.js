// JavaScript Document

function getFileExtension(fname) {

	var pos = fname.lastIndexOf(".");
	
	var strlen = fname.length;
	
	if(pos != -1 && strlen != pos+1) {
	
	var ext = fname.split(".");
	
	var len = ext.length;
	
	var extension = ext[len-1].toLowerCase();
	
	}
	else {
	
		extension = "undefined";
	
	}
	
	return extension;
}

toggleContent = function(obj)
{
	obj.oldtext = obj.value;
	obj.value = "";
	
	obj.onblur = function() {
		if(this.value == ""){
			this.value = this.name;	
		}
	}

}
	