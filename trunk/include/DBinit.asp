<%
//Get DB Info from XML
var xml = Server.CreateObject("Microsoft.XMLDOM");
xml.async = false;
var filexml =  Server.MapPath("include") + "\\db.xml";
//Response.Write(filexml);
xml.load(filexml);
Response.Write(xml.parseError.reason)

//var a = xml.getElementsByTagName("sql_provider").item(0).text
//Response.Write(a);

var objXMLRoot = xml.selectSingleNode("//config")

if(typeof(objXMLRoot) == "object") {
	for(var i =0; i < objXMLRoot.childNodes.length; i++) {
		config[objXMLRoot.childNodes(i).nodeName] = objXMLRoot.childNodes(i).text;
	}
}


Application.Lock();
Application.Contents("site_url")     = config["site_url"];
Application.Contents("upload_path")  = config["upload_path"];
Application.Contents("upload_url")   = config["upload_url"];
Application.Contents("image_ext")    = config["image_ext"];
Application.Contents("image_ext_kb") = config["image_size_kb"];
Session.CodePage = 65001;

Application.Contents("conn_str") = "Provider="+config["sql_provider"]+"; Data Source="+config["sql_datasource"]+"; Initial Catalog="+config["sql_catalog"]+"; User ID="+config["sql_userid"]+"; Password="+config["sql_password"]+";"

Application.UnLock();

var conn = Server.CreateObject("ADODB.Connection");
conn.Open(Application("conn_str"));
var rs   = null;
%>