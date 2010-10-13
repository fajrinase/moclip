<%
var config = new Array();

// Database , filename etc

//config["sql_provider"]	= "Microsoft.Jet.OLEDB.4.0";

config["sql_provider"]		= "SQLNCLI10";
config["sql_datasource"]	= "(local)";
config["sql_catalog"]			= "moclip";
config["sql_userid"]			= "sa";
config["sql_password"]		= "123456";

config["db_name"]					= "moclip";
config["sql_sourcepath"]	= "";

// Site info
config["site_name"]				= "MoClip!";
config["site_url"]				= "http://" + Request.ServerVariables("SERVER_NAME") + "/moclip";
config["site_path"]				= Server.MapPath("/") + "\\moclip";
config["upload_url"]			= config["site_url"] + "/uploads";
//config["upload_path"]			= config["site_path"] + "\\uploads";
config["upload_path"]			= String(Server.MapPath("uploads")).replace(/admin\\/,"");
config["image_url"]				= config["site_url"] + "/images";
config["image_ext"]				= "bmp,gif,jpeg,jpg,jpe,png";
config["image_size_kb"]		= 500;
config["clip_size_mb"]		= 100;

// Company info
config["company_name"]		= "";
config["company_phone"]		= "";
config["company_fax"]		= "";
config["company_email"]		= "";
config["company_address"]	= "";

config["aboutus"]			= "";

//User setting

if( typeof(Session("uid")) == "undifined") {
	Session("uid") = 0;
	Session("username") = "Guest";
	Session("fullname") = "Guest";
}

var user = new Array();
user["id"] = Session("uid");
user["username"] = Session("username");
user["fullname"] = Session("fullname");


//
var is_admin_page = 0
%>