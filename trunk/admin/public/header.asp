<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-gb" lang="en-gb">
<head>
    <title>Admin</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="robots" content="index, follow" />
	<meta name="keywords" content="" />
	<meta name="description" content="MoClip!" />
	<meta name="generator" content="" />
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