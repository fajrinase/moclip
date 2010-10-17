<%

function login()
{
	var username = Request.Form("username");
	var password = Request.Form("password");
	
	if(username == "")
	{
		Response.Write("Username can not blank!");
	}
	
	else if(password == "")
	{
		Response.Write("Password can not blank!");
	}
	
	else
	{
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT top 1 uid, username, fullname  FROM mc_users where username='"+username+"' and password='"+password+"'", conn);
		
				
		if(! rs.EOF)
		{
			rs.MoveFirst;
			Session.Contents("uid") = intval(new String(rs("uid")));
			Session.Contents("username") = new String(rs("username")).toString();
			Session.Contents("fullname") = new String(rs("fullname")).toString();
			
			//Redirect
			//Response.Redirect("?");
			redirect(11, "default.asp" );
		}
		else
		{
			Response.Write("Cannot find your account, please try to login again or click on Forget Pass to get you account again!");
			
		}
		
		
		rs.Close();
		rs = null;	
	}
}

function logout()
{
	Session.Contents("uid") = 0;
	Session.Contents("username") = "Guest";
	Session.Contents("fullname") = "Guest";
	Session.Contents("isAdmin") = false;
	
	//Redirect
	Response.Redirect("?");

}


function accountManager(type)
{
		error_text = "";
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT top 1 *  FROM mc_users where uid='"+user["id"]+"'", conn);
		
		if(! rs.EOF)
		{
			rs.MoveFirst;	
			
			var acc = new Array();		
			
			acc["uid"] = intval(new String(rs("uid")));
			acc["username"] = new String(rs("username")).toString();
			acc["fullname"] = new String(rs("fullname")).toString();			
			acc["address"] = new String(rs("address")).toString();
			acc["address"] = (acc["address"] == "null") ? "" : acc["address"];
			
			acc["phone"] = new String(rs("phone")).toString();
			acc["phone"] = (acc["phone"] == "null") ? "" : acc["phone"];
			
			acc["mobile"] = new String(rs("mobile")).toString();
			acc["mobile"] = (acc["mobile"] == "null") ? "" : acc["mobile"];
			
			acc["email"] = new String(rs("email")).toString();
			
			acc["sex"] = intval(new String(rs("sex")).toString()) == 1 ? "Male" : "Female";
			
			acc["question"] = new String(rs("question")).toString();
			acc["answer"] = new String(rs("answer")).toString();
			
		}
		else
		{
			Response.Write("Cannot find your account, please try to login again or click on Forget Pass to get you account again!");
		}
		
		rs.Close();
		rs = null;	
	//Show register form
	%>
		<!--#include file="register.asp" -->
	<%
	
}

function myProfile(type) 
{

	var error_text = "";
	var acc = new Array();
	acc["address"]  = Request.Form("address");
	acc["answer"]  = Request.Form("answer");
	acc["email"]  = Request.Form("email");
	acc["fullname"]  = Request.Form("fullname");
	acc["mobile"]  = Request.Form("mobile");
	acc["password"]  = Request.Form("password");
	acc["phone"]  = Request.Form("phone");
	acc["question"]  = Request.Form("question");
	acc["repassword"]  = Request.Form("repassword");
	acc["sex"]  = Request.Form("sex");
	acc["username"]  = Request.Form("username");
	
		
	if( type == "update" )
	{
		conn.Execute("UPDATE mc_users SET address='"+safe_query(acc["address"])+"', fullname = '"+safe_query(acc["fullname"])+"', mobile='"+safe_query(acc["mobile"])+"', phone='"+safe_query(acc["phone"])+"', answer='"+safe_query(acc["answer"])+"', sex='"+intval(acc["sex"])+"', email='"+safe_query(acc["email"])+"' where uid="+user["id"]);
		
		
		redirect(11,"?act=user&do=manager");
	}
	else 
	{	
		
		//check pass
		if(acc["password"].length < 4 && acc["password"].length > 32 && acc["password"] != acc["repassword"] ) 
		{
			error_text = "Password is incorrect";
		}
		
		if(!acc["email"])
		{
			error_text = "Invalid Email";
		}
		
		if(!acc["username"])
		{
			error_text = "Invalid Username";
		}
		
		if(!acc["fullname"])
		{
			error_text = "Invalid Fullname";
		}
		
		if(acc["question"] == "null")
		{
			error_text = "Invalid Question";
		}
		
		if(!isset(acc["answer"]))
		{
			error_text = "Invalid Answer";
		}
		
		//Check username
		rs = Server.CreateObject("ADODB.Recordset");
		rs.Open("SELECT top 1 *  FROM mc_users where username='"+acc["username"]+"'", conn);		
		if(! rs.EOF)
		{
			error_text = "Username is already exist";	
			rs.Close();
			rs = null;		
		}
		else 
		{
			rs.Close();
			rs = null;
			//Check email
			rs = Server.CreateObject("ADODB.Recordset");
			rs.Open("SELECT top 1 *  FROM mc_users where email='"+acc["email"]+"'", conn);		
			if(! rs.EOF)
			{
				error_text = "Email is already exist";			
			}
			rs.Close();
			rs = null;	
		}
		
		//Handle
		if(error_text == "") 
		{
			var d = new Date();
			var curtime = (d.getMonth() + 1) + "/"+ d.getDate() + "/" + d.getFullYear() + " " + d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds() + "." + d.getMilliseconds();
						
			conn.Execute("INSERT INTO mc_users (fullname, username,[password], email, phone, mobile, question, answer, address, sex, date_joined) VALUES('" + safe_query(acc["fullname"]) + "','" + safe_query(acc["username"]) + "','" + safe_query(acc["password"]) + "','" + safe_query(acc["email"]) + "','" + safe_query(acc["phone"]) + "','" + safe_query(acc["mobile"]) + "','" + safe_query(acc["question"]) + "','" + safe_query(acc["answer"]) + "','" + safe_query(acc["address"]) + "','" + intval(acc["sex"]) + "','" + curtime +"')");
		
			//Back to home page
			redirect(10,"?");
		}
	}
	
	if(error_text != "") 
	{
		//Show register form
		%>
			<!--#include file="register.asp" -->
		<%
	}
}



/**
*	Action Switch
**/
var doexc = Request.QueryString("do");

if(doexc == "login") {
	login();
}

else if(doexc == "logout") {
	logout();
}

else if(doexc == "manager") {
	if(user["id"])
	accountManager();
	else
	Response.Write("You are not login now! Please login first.");
}

else if(doexc == "domanager") {
	myProfile("update");
}

else if(doexc == "register") {
	myProfile("new");
}
else {
	
}

%>