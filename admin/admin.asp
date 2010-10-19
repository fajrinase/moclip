<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!-- METADATA TYPE="typelib" FILE="C:\Program Files\Common Files\System\ado\msado15.dll" -->
<!--#include virtual ="moclip/include/config.asp" -->
<!--#include virtual ="moclip/include/function.asp" -->
<!--#include virtual ="moclip/include/DBinit.asp" -->
<%
is_admin_index = 1;
%>
<!--#include file="public/header.asp"-->
<%
if(admin["id"] > 0 && Session("isAdmin") == true)
{
%>
		<div id="header">
            <a href="#" class="logo">MoClip!</a>
            <ul id="top-navigation">
                <li><a href="admin.asp" class="active">Homepage</a></li>
                <li><a href="user.asp">Users</a></li>
                <li><a href="clip.asp">Clips</a></li>
                <li><a href="channel.asp">Channel</a></li>
                <li><a href="comment.asp">Comments</a></li>
                <li><a href="system.asp">System</a></li>
                <li><a href="suggestion.asp">Suggestion</a></li>
				<li><a href="admin.asp?act=logout">Logout</a></li>
            </ul>
        </div>
		
 		<div id="middle">
			<div id="left-column">
				<h3>Menu</h3>
				<ul class="nav">
					<li><a href="#">Dashboard</a></li>				
				</ul>                
			 </div>
			<div id="center-column">
				<div class="top-bar">
					<%=now%>
				</div>
				
				<div class="table">
				   
				</div>
						   
			</div>            
		</div><!--Ennd main-->
		<!--#include file="public/footer.asp"-->
<%
}
else
{
%>
		<div class="login-panel">
			<form method="post" action="admin.asp?act=login">
			<div>
				<span>Username:</span>
				<input type="text" name="username" value=""/>
			</div>
			<div>
				<span>Password:</span>
				<input type="password" name="password" value=""/>
			</div>
			<div>
				<input type="reset" value="Cancel"/>
				<input type="submit" value="Login"/>
			</div>			
		</div>
	</div>
</body>
</html>
<%
}

var action = new String(Request.QueryString("act")).toString();

if(action == "login")
{
	dologin();
}
else if(action == "logout")
{
	dologout();
}

function dologin()
{
	var username = Request.Form("username");
	var password = Request.Form("password");
	
	if(username == "")
	{
		Response.Write("<center>Username can not blank!</center>");
	}
	
	else if(password == "")
	{
		Response.Write("<center>Password can not blank!</center>");
	}
	
	else
	{
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT uid, username, fullname  FROM mc_users where username='"+username+"' and password='"+password+"' and allow_acp=1", conn);
		
				
		if(! rs.EOF)
		{
			rs.MoveFirst;
			Session.Contents("admin_uid") = intval(new String(rs("uid")));
			Session.Contents("admin_username") = trim(new String(rs("username")).toString());
			Session.Contents("admin_fullname") = trim(new String(rs("fullname")).toString());
			Session.Contents("isAdmin") = true;
			
			//Redirect
			redirect(1, "admin.asp" );
		}
		else
		{
			Response.Write("<center>Can not find your account or you are not allow to access Admin</center>");
			
		}
		
		
		rs.Close();
		rs = null;	
	}
}

function dologout()
{
	Session.Contents("admin_uid") = 0;
	Session.Contents("admin_username") = "Guest";
	Session.Contents("admin_fullname") = "Guest";
	Session.Contents("isAdmin") = false;
	
	//Redirect
	redirect(2, "admin.asp" );

}

%>
