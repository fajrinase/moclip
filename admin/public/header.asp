<!DOCTYPE html>
<html>
<head>
    <title>Admin</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link  href="css/admin.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div id="main">
	<%
		is_admin_page = 1
		if( admin["id"] < 1 || !Session("isAdmin"))
		{			
			if( is_admin_index != 1 )
				Response.Redirect("admin.asp");
		}
	%>