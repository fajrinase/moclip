<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-gb" lang="en-gb">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="robots" content="index, follow" />
<meta name="keywords" content="" />
<meta name="description" content="MoClip!" />
<meta name="generator" content="" />
<title>MoClip!</title>
<link href="/jv_inci/templates/jv_inci/favicon.ico" rel="shortcut icon"	type="image/x-icon" />

<link rel="stylesheet" href="public/css/jv.moomenu.css" type="text/css" />
<link rel="stylesheet" href="public/css/horizotal.css" type="text/css" />
<script type="text/javascript" src="public/js/mootools.js"></script>
<script type="text/javascript" src="public/js/horizotal.js"></script>
<script type="text/javascript" src="public/js/site.js"></script>


<script type="text/javascript" src="public/js/jv.moomenu.js"></script>

<link rel="stylesheet" href="public/css/default.css" type="text/css" />
<link rel="stylesheet" href="public/css/template.css" type="text/css" />

<!--[if lte IE 6]>
	<link rel="stylesheet" href="public/css/ie6.css" type="text/css" />
	<script type="text/javascript" src="public/js/ie_png.js"></script>
	<script type="text/javascript">
	window.addEvent ('load', function() {
	   ie_png.fix('.png');
	});
	</script>
	<![endif]-->
<!--[if lte IE 7]>
	<link rel="stylesheet" href="public/css/ie7.css" type="text/css" />
	<![endif]-->
</head>
<body id="bd" class="fs3 ltr">
<div id="jv-wrapper">
	<div id="jv-wrapper-inner">
		<div id="jv-header" class="clearfix">
			<div class="jv-wrapper">

				<div id="jv-header-inner">
					<div id="jv-top">
						<ul class="menu">
							<li class="item28 first">
								<a href="default.asp"><span>Home</span></a>
							</li>
						</ul>
					</div>

					<div id="jv-mainmenu">
						<div class="jv-mainmenu-l"></div>
						<div id="jv-mainmenu-inner">
							<div class="menusys_moo">
								<ul id="menusys_moo">
									<li class="first-item">
										<a href="#" class=' item' id="menusys1" title="Home"><span class="menusys_name">Home</span></a>
									</li>
									<li class=" hasChild">
										<a href="#" class=' item' id="menusys27" title="Video"><span class="menusys_name">Videos</span></a>
										<ul>
											<li class="first-item">
												<a href="default.asp?act=channel&do=tophit" class=' item' id="menusys60" title="Top View"><span class="menusys_name">Top View</span></a>
											</li>
											<li class="last-item">
												<a href="default.asp?act=channel&do=toprate" class=' item' id="menusys61" title="Top Rate"><span class="menusys_name">Top Rate</span></a>
											</li>											
										</ul>
									</li>
									<li class=" hasChild">
										<a href="default.asp?act=channel&do=all" class=' item' id="menusys2" title="Channel"><span class="menusys_name">Channels</span></a>
										<ul>
											<% displayChannelMenu(); %>
										</ul>
									</li>
									<li class="">
										<a href="?act=upload" class=' item' id="menusys2" title="Upload"><span class="menusys_name">Upload Clip</span></a>
									</li>
									<li class="">
										<a href="?act=search" class=' item' id="menusys2" title="Search"><span class="menusys_name">Search</span></a>
									</li>
									<li class=" last-item hasChild">
										<a href="#"	class=' item' id="menusys37" title="Content"><span class="menusys_name">My Account</span></a>
										<ul class='loginpanel'>
											<%
												if(user["id"] > 0) {
													Response.Write("<li><span style='padding-left : 10px;'>"+user["fullname"]+"</span></li>");
													Response.Write("<li><a class=' item'  href='?act=user&do=manager'><span class='menusys_name'>Manager Account</span></a></li>");
													Response.Write("<li><a class=' item'  href='?act=user&do=logout'><span class='menusys_name'>Logout</span></a></li>");
												}
												else
												{
													Response.Write("<li>");
													Response.Write("<form name='userlogin' action='?act=user&do=login' method='POST'>");
													Response.Write("<div><input type='text' name='username' value='username' onfocus='toggleContent(this);'/></div>");
													Response.Write("</li>");
													Response.Write("<li>");
													Response.Write("<div><input class='password' type='password' name='password' value='****' onfocus='toggleContent(this);' /></div>");
													Response.Write("</li>");
													Response.Write("<li>");
													Response.Write("<div style='font-size:10px;margin-left: 15px;'><span onclick=\"window.location = '?act=forgetpass';\" alt='Get My Password again' >Forget Pass!</span><input class='submit' type='submit' value='Login'/></div>");
													Response.Write("</form>");
													Response.Write("</li>");
													Response.Write("<li>");
													Response.Write("<a  class='item' href='?act=register'><span class='menusys_name'>Register Now</span></a>");
													Response.Write("</li>");
												}
												
											%>
										</ul>
									</li>
								</ul>
							</div>
						</div>
						<div class="jv-mainmenu-r"></div>
					</div>

					<div id="jv-logo" class="clearfix">
						<h1 id="logo">
							<a class="png" href="#" title="MoCLip!"><span>MoCLip!</span></a>
						</h1>
					</div>

				</div>
			</div>
		</div>

		<div id="jv-slideshow" class="clearfix">
			<div id="jv-slideshow2">
				<div class="jv-wrapper">
					<div id="jv-slideshow-inner">
						<script type="text/javascript">
							window.addEvent('load', function() {
								var slid = new noobSlide( {
									box : $('jvcarousel46'),
									items : $ES('.jvcarousel-slide', 'jvcarousel46'),
									size : 980,
									handles : $ES('.handles_item', 'handles46'),
									interval : 5000,
									play : function(delay, direction, wait) {
										delay: 100;
										direction: "next";
										wait: true;
									},
									onWalk : function(currentItem, currentHandle) {
										this.handles.removeClass('active');
										currentHandle.addClass('active');
									},
									autoPlay : 1
								});
								slid.play;
							});
						</script>

						<div class="mod_jvsello2_headline" style="height: 117px; width: 980px">

						<div class="jvcarousel_frame" style="height: 117px; width: 980px">
							<div class="jvcarousel" id="jvcarousel46">
								<div class='jvcarousel-slide' style='width: 980px'>
									<div class="jvcarousel-item" style="width: 953px">
										<%=getRandom5Clip()%>
									</div>
								</div>
								<div class='jvcarousel-slide' style='width: 980px'>
									<div class="jvcarousel-item" style="width: 953px">
										<%=getRandom5Clip()%>
									</div>
								</div>
								<div class='jvcarousel-slide' style='width: 980px'>
									<div class="jvcarousel-item" style="width: 953px">
										<%=getRandom5Clip()%>
									</div>
								</div>
							</div>
						</div>

						</div>

						<div class="jvcarousel-pagi clearfix">
							<p class="buttons handles" id="handles46">
								<span class='handles_item active'> 1 </span>
								<span class='handles_item'>2 </span>
								<span class='handles_item'> 3 </span>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>



		<!-- MAINBODY -->
		<div id="jv-mainbody" class="clearfix">
			<div class="jv-wrapper">
				<div id="jv-mainbody-inner">
				<!-- CONTAINER -->
					<div id="jv-container-left" class="clearfix">

						<div id="jv-left">
							<div id="jv-left-inner">
								<div class="module box">
									<div class="jv-tc">
										<div class="jv-tl"></div>
										<div class="jv-tr"></div>
									</div>
									
									<div class="jv-c clearfix">
										<div class="jv-c2">
											<h3 class="moduletitle png"><span>Main Menu</span></h3>
											<div class="jv-inside clearfix">
												<ul class="menu">
													<li class="item53 first">
														<a href="default.asp"><span>Home</span></a>
													</li>
													<li class="item54">
														<a href="default.asp?act=channel&do=tophit"><span>Top Hits</span></a>
													</li>
													<li class="item55">
														<a href="default.asp?act=channel&do=toprate"><span>Top Rate</span></a>
													</li>
													<li class="item56">
														<a href="default.asp?act=channel&do=all"><span>Browse</span></a>
													</li>
													<li id="current" class="active item59">
														<a href="default.asp?act=search"><span>Search</span></a>
													</li>
													<li class="item58">
														<a href="default.asp?act=suggestion"><span>Suggestion</span></a>
													</li>
													<li class="item57 last">
														<a href="default.asp?act=contact"><span>Contact Us</span></a>
													</li>
												</ul>
											</div>
										</div>
									</div>
									<div class="jv-bc clearfix">
										<div class="jv-bl"></div>
										<div class="jv-br"></div>
									</div>
								</div>

							</div>
						</div>


						<div id="jv-content">

							<div id="jv-breadcrumbs">
								<strong class="icon-home">You are here:</strong> 
								<span class="breadcrumbs pathway"> 
									<a href="default.asp" class="pathway">Home</a>
								</span>
							</div>

							<div id="jv-maincontent" class="clearfix">
								<div class="jv-tc">
									<div class="jv-tl"></div>
									<div class="jv-tr"></div>
								</div>
								<div class="jv-c clearfix">
									<div class="jv-c2">
										<div id="jv-maincontent-inner">
											<div id="jv-component" class="clearfix">
											<!--Main body content-->
												<div id="vmMainPage">