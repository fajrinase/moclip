<%

step = intval(Request.QueryString("step"));

if(step == 1) {
	getAccount();
}
else if(step == 2) {
	getPassword();
}
else {
	showForm();
}

function showForm() 
{
%>
	
	<div class="view-clip-title">Retrieve Password</div>
	<div style="width:60%; float:left">
	<form name="uploadClip" class="search-form" onsubmit="return checkform(this)" method="post" action="default.asp?act=forgetpass&step=1" autocomplete="off">
		<div>
			<span style="width:70px">Username: </span>
			<input type="text" name="username" value="" />
		</div>
		<span style="text-align:center">or</span>
		<div>
			<span style="width:70px">Email: </span>
			<input type="text" name="email" value="" />
		</div>
		<div style="text-align:center">
			<input type="submit" value="Next Step" class="shareit" />
		</div>
	<form>
	<script type="text/javascript">
		checkform = function(o) {
			if(o.username.value.length < 4 && o.email.value.length < 4) {
				alert("Please enter your username or email.")
				o.username.focus();
				return false;				
			}
			if(o.email.value.length >= 4) {
				var re = /^([\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+\.)*[\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)$/i;
				
				if (!o.email.value.match(re)) {
					alert("Your Email is not correct, email must be like abc@domain.com");
					o.email.focus();
					return false;		
				} 
			}
			if(o.username.value.length >= 4) {
				var re = /[a-zA-Z0-9]$/;
				if (!o.username.value.match(re)) {
					alert("Username can not content special character!");
					o.username.focus();
					return false;		
				} 
			}
		}
	</script>
	</div>
	<div style="width:40%; float:left">
		<b>Attention</b>: To retrive your password you must input either your username or your email to process next step.
		<br /><br />
		If you don't remember your username or email please contact our admin, we are very pleasure to help you.
	</div>
	
	<div style="clear:left"></div>
<%
}

function getAccount()
{
	
	var username = trim(Request.Form("username"));
	var email = trim(Request.Form("email"));
	
	if(username != "" || email != "") 
	{
		var query = "select uid from mc_users where uid > 1";
		if(username != "")
			query += " and username='"+username+"'";
		if(email != "")
			query += " and email='"+email+"'";
			
		rs = Server.CreateObject("ADODB.Recordset");	
		
		rs.open(query, conn);
		if(!rs.EOF) {
			rs.MoveFirst;
			%>
				<div class="view-clip-title">Security Question</div>
				<div style="width:60%; float:left">
				<form name="uploadClip" class="search-form" onsubmit="return checkform(this)" method="post" action="default.asp?act=forgetpass&step=2" autocomplete="off">
				<input type="hidden" name="username" value="<%=username%>" />
				<input type="hidden" name="email" value="<%=email%>" />
				<input type="hidden" name="uid" value="<%=rs("uid")%>" />
					<div>
						<span style="width:70px">Question: </span>
						<%
							Response.Write("<select name='question' id='question'>");
							Response.Write("<option selected='selected' value='null'>Please select a question</option>");
							Response.Write("<option>What was your childhood nickname?</option>");
							Response.Write("<option>Where were you when you had your first kiss? </option>");
							Response.Write("<option>In what city or town did your mother and father meet? </option>");
							Response.Write("<option>In what city or town was your first job?</option>");
							Response.Write("<option>Who was your childhood hero? </option>");
							Response.Write("<option>What is your mother's middle name? </option>");
							Response.Write("<option>What is the name of the place your wedding reception was held?</option>");
							Response.Write("<option>What street did you live on in third grade?</option>");
							Response.Write("<option>What is your beloved name?</option>");
							Response.Write("</select>");
						%>
					</div>
					
					<div>
						<span style="width:70px">Answer: </span>
						<input type="text" name="answer" value="" />
					</div>
					<div style="text-align:center">
						<input type="submit" value="Next Step" class="shareit" />
					</div>
				<form>
				<script type="text/javascript">
					checkform = function(o) {
						//checking question and answer
						if(o.question.value == "null") {
							alert("Please select a question!");
							o.question.focus();
							return false;
						}
						
						if(o.answer.value.length < 4) {
							alert("Answer can not shorter than 4 character");
							o.answer.focus();
							return false;
						}
							
						if(o.answer.value.length > 100) {
							alert("Answer can not longer than 100 character");
							o.question.focus();
							return false;
						}						
					}
				</script>
				</div>
				<div style="width:40%; float:left">
					<b>Attention</b>: You have to choose a question that you have chosen when you registered.
					<br />
					And correct answer that you had given.
				</div>
				
				<div style="clear:left"></div>
			<%		
		}
		else {
			Response.Write("Can not find your account in our system. Please try again or <a alt='Register' title='Register' href='default.asp?act=register'>click here to register new Account</a>");
			showForm();
		}
		
		rs.Close();
		rs = null;
		
	}
	else {
		Response.Write("Please enter username or Email!");
	}
	
}

function getPassword()
{
	var username = trim(Request.Form("username"));
	var email = trim(Request.Form("email"));
	var uid = intval(Request.Form("uid"));
	var question = trim(Request.Form("question"));
	var answer = trim(Request.Form("answer"));
	
	if(question != "" && answer != "" && uid > 0) {
		var query = "select username, password from mc_users where uid="+uid+" and question='"+question+"' and answer='"+answer+"'";	
		if(username != "")
			query += " and username='"+username+"'";
		if(email != "")
			query += " and email='"+email+"'";
			
		rs = Server.CreateObject("ADODB.Recordset");	
		
		rs.open(query, conn);
		if(!rs.EOF) {
			rs.MoveFirst;
			%>
				<div class="view-clip-title">Lucky! We've found your account.</div>
				<div style="width:60%; float:left">
				<form name="uploadClip" class="search-form" onsubmit="return checkform(this)" method="post" action="default.asp?act=user&do=login&follow=changepassword" autocomplete="off">
				<input type="hidden" name="username" value="<%=trim(rs("username"))%>" />
				<input type="hidden" name="email" value="<%=email%>" />
				<input type="hidden" name="uid" value="<%=uid%>" />
					<div>
					<span>Your password:</span>
						<input type="text" name="password" value="<%=trim(rs("password"))%>" readonly />
					</div>
					<div>
						<span style="width:350px; color:#CC0000">You can change your password now</span>
					</div>
					<div>
						<span>New Password</span>
						<input class="password" type="password" name="newpass" value="">
					</div>
					<div>
						<span>Re enter Password</span>
						<input class="password" type="password" name="renewpass" value="">
					</div>
					<div style="text-align:center">
						<input type="submit" name="" value="Change Password" class="shareit"/>
					</div>				
				</form>	
				<script type="text/javascript">
					checkform = function(o) {
						//checking question and answer
							
						if(o.newpass.value.length < 4) {
							alert("Password can not shorter than 4 character");
							o.newpass.focus();
							return false;
						}
						else {
							if(o.newpass.value == o.password.value) {
								alert("New password must not same current password");
								o.newpass.focus();
								return false;
							}
							else if(o.newpass.value != o.renewpass.value) {
								alert("New password and Re enter Password are not same");
								o.newpass.focus();
								return false;
							}
						}	
									
					}
				</script>		
			<%			
		}
		else
		{
			Response.Write("Can not find your account in our system. Please try again or <a alt='Register' title='Register' href='default.asp?act=register'>click here to register new Account</a>");
		}
			
	}
	else {
		Response.Write("Please enter question and Answer!");
	}
}

%>