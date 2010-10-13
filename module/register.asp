<form name="uploadClip" method="POST" action="?act=user&do=<%=(typeof(acc["uid"]) != "undefined") ? "domanager" : "register"%>">
	<table width="100%">
		<tr>
			<td width="60%">
				<table width="100%">
					<caption style="text-align:left; font-size: 20px; font-weight: bold;"><%
						if(typeof(acc["uid"]) != "undefined")
						{
							var submittext = "Update Profile!";
							Response.Write("Manage My Profile");
						}
						else
						{
							var submittext = "Register";
							Response.Write("Register New Account");
						}
					%></caption>
					
					<tr>
						<td>
							<label for="fullname">Full Name<span style="color:#FF0000 !important">*</span></label>
						</td>
						<td>
							<input id="fullname" type="text"  name="fullname" value="<%=acc["fullname"]%>" />
						</td>
					</tr>
									
					
					<%
					if(typeof(acc["uid"]) == "undefined")
						{
							Response.Write("<tr><td><label for='Username'>Username<span style='color:#FF0000 !important'>*</span></label></td><td><input id='Username' type='text'  name='username' value='' /></td></tr>");
							
							
							Response.Write("<tr><td><label for='password'>Password<span style='color:#FF0000 !important'>*</span></label></td>");
							Response.Write("<td><input class='password' id='password' type='password'  name='password' value='' /></td></tr>");
							
							Response.Write("<tr><td><label for='password1'>RePassword<span style='color:#FF0000 !important'>*</span></label></td>");
							Response.Write("<td><input class='password' id='password1' type='password'  name='repassword' value='' /></td></tr>");
						}
					%>
					
					<tr>
						<td>
							<label for="email">Email<span style="color:#FF0000 !important">*</span></label>
						</td>
						<td>
							<input id="email" type="text"  name="email" value="<%=acc["email"]%>" />
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="Address">Address</label>
						</td>
						<td>
							<input id="Address" type="text"  name="address" value="<%=acc["address"]%>" />
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="phone">Telephone</label>
						</td>
						<td>
							<input id="phone" type="text"  name="phone" value="<%=acc["phone"]%>" />
						</td>
					</tr>
					
									
					<tr>
						<td>
							<label for="mobile">Mobile</label>
						</td>
						<td>
							<input id="mobile" type="text"  name="mobile" value="<%=acc["mobile"]%>" />
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="sex">Sex</label>
						</td>
						<td>
							<input type="radio" value='1' name="sex"  <% if(acc["sex"] == "Male") Response.Write("checked='checked'");%> />Male
							<input type="radio" value='0' name="sex" <% if(acc["sex"] == "Female") Response.Write("checked='checked'"); %> />Female
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="question">Question<span style="color:#FF0000 !important">*</span></label>
						</td>
						<td>
						<%
						if(typeof(acc["uid"]) == "undefined")
						{
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
						}
						else
						{
							Response.Write("<input id='question' type='text'  name='question' value='"+acc["question"]+"' readonly />");
						}%>	
						</td>
					</tr>
					
					<tr>
						<td>
							<label for="Answer">Answer<span style="color:#FF0000 !important">*</span></label>
						</td>
						<td>
							<input id="Answer" type="text"  name="answer" value="<%=acc["answer"]%>" />
						</td>
					</tr>
					
					
					
					<tr>
						<td colspan="2" align="center">
							<input type="reset"  name="reset" value="Reset" />
							<input type="submit" class="shareit"  name="submit" value="<%=submittext%>" onclick="return submitShareForm()"/>
						</td>
					</tr>
				</table>
			</td>
			<td width="40%" valign="top">
				<div style="margin-top: 25px;">When register you can</div>
				<ul style="list-style-type:circle; margin-top: 5px;">
					<li>Upload a Clip</li>
					<li>Comment on user's clip.</li>
					<li>Rating a clip.</li>
					<li>Unlimited access.</li>
					<li>And more...</li>
				</ul>
				<div style="margin-top: 25px;">Please register now!!!</div>
			</td>
		</tr>
	</table>
</form>

<script type="text/javascript">

submitShareForm = function() {
	var form = document.uploadClip;
	
	for(var i = 0; i < form.length; i++) {
		//Checkin fullname
		if(form[i].name == "fullname" ) {
			if(form[i].value.length > 0) {
				if(form[i].value.length < 5) {
					alert("Fullname can not shorter than 5 character");
					form[i].focus();
					return false;
				}
				
				if(form[i].value.length > 32) {
					alert("Fullname can not longer than 32 character");
					form[i].focus();
					return false;
				}
				
				var num = /\d+/
				if(num.test(form[i].value)) {
					alert("Fullname can not content number");
					form[i].focus();
					return false;
				}
							
			}else {
				alert("Fullname can not blank");
				form[i].focus();
				return false;
			}
			
		}
		//Checkin username
		if(form[i].name == "username" ) {
			if(form[i].value.length > 0) {
				if(form[i].value.length < 4) {
					alert("Username can not shorter than 4 character");
					form[i].focus();
					return false;
				}	
				if(form[i].value.length > 32) {
					alert("Username can not longer than 32 character");
					form[i].focus();
					return false;
				}
			}else {
				alert("Username can not blank");
				form[i].focus();
				return false;
			}
			
		}
		//Check password and repassword
		if(form[i].name == "password" ) {
			if(form[i].value.length > 0) {	
				if(form[i].value.length < 4) {
					alert("Password can not shorter than 4 character");
					form[i].focus();
					return false;
				}			
				if(form[i].value.length > 32) {
					alert("Password can not longer than 32 character");
					form[i].focus();
					return false;
				}
				if( form[i].value != form.repassword.value ) {
					console.log(form[i].value + ' = ' +form.repassword.value)
					alert("Password and Repassword does not match.");
					form[i].focus();
					return false;
				}
			}else {
				alert("Password can not blank");
				form[i].focus();
				return false;
			}
			
		}
		//checkin Email
		if(form[i].name == "email" ) {
			if(form[i].value.length > 0) {	
				if(form[i].value.length > 64) {
					alert("Email can not longer than 64 character");
					form[i].focus();
					return false;
				}
								
				ok = "1234567890qwertyuiop[]asdfghjklzxcvbnm.@-_QWERTYUIOPASDFGHJKLZXCVBNM";

				for(var j=0; j < form[i].value.length ;j++){
					if(ok.indexOf(form[i].value.charAt(i))<0) { 
						alert("Your email contents invalid character.");
						form[i].focus();
						return false;
					}	
				} 
				
				re = /^([\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+\.)*[\w\!\#$\%\&\'\*\+\-\/\=\?\^\`{\|\}\~]+@((((([a-z0-9]{1}[a-z0-9\-]{0,62}[a-z0-9]{1})|[a-z])\.)+[a-z]{2,6})|(\d{1,3}\.){3}\d{1,3}(\:\d{1,5})?)$/i;

				if (!form[i].value.match(re)) {
					alert("Your Email is not correct, email must be like abc@domain.com");
					form[i].focus();
					return false;		
				} 
			

			}else {
				alert("Email can not blank");
				form[i].focus();
				return false;
			}
			
		}
		
		//checking question and answer
		if(form[i].name == "question") {
			if(form[i].value == "null") {
				alert("Please select a question!");
				form[i].focus();
				return false;
			}
		}
		if(form[i].name == "answer") {
			if(form[i].value.length < 4) {
				alert("Answer can not shorter than 4 character");
				form[i].focus();
				return false;
			}
			
			if(form[i].value.length > 100) {
				alert("Answer can not longer than 100 character");
				form[i].focus();
				return false;
			}
		}
	}
	

}


</script>