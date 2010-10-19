<%
var config = new Array();
// Site info
config["site_name"]				= "MoClip!";
config["site_url"]				= "http://" + Request.ServerVariables("SERVER_NAME") + "/moclip";
config["site_path"]				= Server.MapPath("/") + "\\moclip";
config["upload_url"]			= config["site_url"] + "/uploads";
//config["upload_path"]			= config["site_path"] + "\\uploads";
config["upload_path"]			= String(Server.MapPath("uploads")).replace(/admin\\/,"");
config["include_path"]			= String(Server.MapPath("include")).replace(/admin\\/,"");
config["image_url"]				= config["site_url"] + "/public/images";
config["image_ext"]				= "bmp,gif,jpeg,jpg,jpe,png";
config["clip_ext"]				= "mp4,flv";

config["image_size_kb"]		= 1024;
config["clip_size_mb"]		= 100;

// Company info
config["company_name"]		= "";
config["company_phone"]		= "";
config["company_fax"]		= "";
config["company_email"]		= "";
config["company_address"]	= "";

config["aboutus"]			= "";

//User setting

if( typeof(Session("uid")) == "undefined" || Session("uid") < 1) {
	Session("uid") = 0;
	Session("username") = "Guest";
	Session("fullname") = "Guest";	
}

var user = new Array();
user["id"] = Session("uid");
user["username"] = Session("username");
user["fullname"] = Session("fullname");

//Admin
if( typeof(Session("admin_uid")) == "undefined" || Session("admin_uid") < 1) {
	
	Session("admin_uid") = 0;
	Session("admin_username") = "Guest";
	Session("admin_fullname") = "Guest";
	Session("isAdmin") = false;
}

var admin = new Array();
admin["id"] = Session("admin_uid");
admin["username"] = Session("admin_username");
admin["fullname"] = Session("admin_fullname");

//
var is_admin_page = 0
var is_admin_index = 0

var cur_date = new Date();
var now = (cur_date.getMonth() + 1) + "/"+ cur_date.getDate() + "/" + cur_date.getFullYear() + " " + cur_date.getHours() + ":" + cur_date.getMinutes() + ":" + cur_date.getSeconds();
%>