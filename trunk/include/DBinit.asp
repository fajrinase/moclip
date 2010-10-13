<%
Application.Lock();
Application.Contents("site_url")     = config["site_url"];
Application.Contents("upload_path")  = config["upload_path"];
Application.Contents("upload_url")   = config["upload_url"];
Application.Contents("image_ext")    = config["image_ext"];
Application.Contents("image_ext_kb") = config["image_size_kb"];
Session.CodePage = 65001;


if(config["sql_provider"] == "SQLNCLI10")
{
	Application.Contents("conn_str") = "Provider="+config["sql_provider"]+"; Data Source="+config["sql_datasource"]+"; Initial Catalog="+config["sql_catalog"]+"; User ID="+config["sql_userid"]+"; Password="+config["sql_password"]+";"
}
else if(config["sql_provider"] == "Microsoft.Jet.OLEDB.4.0")
{
	Application.Contents("conn_str") = "Provider=Microsoft.Jet.OLEDB.4.0 ; Data Source="+String(Server.MapPath("database\\"+config["db_name"]+".mdb;")).replace(/admin\\/,"");
}


Application.UnLock();

var conn = Server.CreateObject("ADODB.Connection");
conn.Open(Application("conn_str"));
var rs   = null;
%>