
<!-- Author: Akshay -->
<?php
$your_email ='';
session_start();
if(isset($_POST['submit'])){

if(empty($_SESSION['6_letters_code']) ||
	  strcasecmp($_SESSION['6_letters_code'], $_POST['6_letters_code']) != 0)
	{
		$errors .= "\n The captcha code does not match!";
		echo "<script>alert('The captcha code does not match!')</script>";
	}
if(empty($errors)){
include "lib/config.php";

$title = mysql_real_escape_string($_POST['title']);
$authors = mysql_real_escape_string($_POST['authors']);
$comments = mysql_real_escape_string($_POST['comments']);
$abstract = mysql_real_escape_string($_POST['abstract']);
$presentation=mysql_real_escape_string($_POST['presentation']);
$inserted = mysql_query("INSERT INTO abstracts2014(title, authors, abstract,presentation,comments) VALUES('$title','$authors','$abstract','$presentation','$comments')");
$mysqlerror=mysql_errno();
		if (mysql_errno() == 1062) {
			    echo "<script>alert('abstract with the title already present')</script>";
			  
		}
		elseif(!empty($mysqlerror)) {
			$error = "MySQL error ".mysql_errno().": ".mysql_error();
			echo "<script>alert('$error');</script>";
			echo "<script>alert('Error submitting abstract. Please try again')</script>";
		}

}
if($inserted)
		{
          

			/*$to = $your_email;
			$subject="New Abstract Submitted";
			$from = "renate@asu.edu";
			$ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
			$title = ucfirst(strtolower($title));
			$authors = ucfirst(strtolower($authors));
                        $abstract = ucfirst(strtolower($abstract));
			$body = "An Abstract with title $title submitted:\n".
			"\ntitle: $title\n".
			"Authors: $authors\n".
			"Abstract: $abstract \n".
			"\nRegards,\n".
			"IT Support";
			$headers = "From: $from \r\n";

			mail($to, $subject, $body,$headers);*/

			echo "<script>alert('Abstract Submitted.')</script>";

		}
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CRCNS</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="shortcut icon" href="/sites/all/themes/asuzen/favicon.ico" type="image/x-icon" />
<link type="text/css" rel="stylesheet" media="all" href="/files/css/css_86f38d3a519e3b1534114fcecb12a5d9.css" />
<link type="text/css" rel="stylesheet" media="print" href="/files/css/css_7603a30a4228e045a456bfdc79db4832.css" />
<link type="text/css" rel="stylesheet" media="screen" href="/sites/all/themes/asuzen/custom.css" />
<script type="text/javascript" src="/misc/jquery.js?Z"></script>
<script type="text/javascript" src="/misc/drupal.js?Z"></script>
<script type="text/javascript" src="/files/images/rotate/jquery.innerfade.js?Z"></script>
<script type="text/javascript" src="/sites/all/themes/asuzen/ie6png.js?Z"></script>
<script language="javascript" src="/scripts/rotate_node_2577_m.js">
</script>
<style>
.author{ padding-left:3.2em}
.affiliation{ padding-left:2.1em}
.email{ padding-left:3.4em}
</style>
<link rel="stylesheet" href="http://www.asu.edu/asuthemes/2.0/custom/d6/css/header_nav_d6.css" type="text/css" />
<link rel="stylesheet" href="http://www.asu.edu/asuthemes/2.0/css/asu_footer.css" type="text/css" />
  <!--[if lte IE 6]>
  <link rel="stylesheet" href="http://www.asu.edu/asuthemes/2.0/custom/d6/css/ie-classic_d6.css" type="text/css" media="screen" />
  <![endif]-->
  <!--[if IE 7]>
  <link rel="stylesheet" href="http://www.asu.edu/asuthemes/2.0/custom/d6/css/ie-vista_d6.css" type="text/css" media="screen" />
  <![endif]-->

  <!--[if IE 8]>
  <link rel="stylesheet" href="http://www.asu.edu/asuthemes/2.0/css/ie-eight.css" type="text/css" media="screen" />
  <![endif]-->

	 <link rel="stylesheet" href="https://www.asu.edu/asuthemes/2.0/custom/d6/css/header_nav_d6.css" type="text/css" />

  
	 <link rel="stylesheet" href="https://www.asu.edu/asuthemes/2.0/css/asu_footer.css" type="text/css" />

<!--[if IE]>
<link type="text/css" rel="stylesheet" media="all" href="/sites/all/themes/zen/zen/ie.css?Z" />
<![endif]-->

<script type="text/javascript">
<!--//--><![CDATA[//><!--
jQuery.extend(Drupal.settings, { "basePath": "/" });
//--><!]]>
</script>
<script type="text/javascript">
<!--//--><![CDATA[//><!--

$(document).ready(function(){
$("#rotate-image img").show();
$("#rotate-image").innerfade({
speed: 1000,
timeout: 5000,
type: "sequence",
containerheight: "132px"
});
});

//--><!]]>

</script>
<link rel="stylesheet" href="http://www.asu.edu/asuthemes/2.0/custom/d6/css/print_d6.css" type="text/css" media="print" />




<!--[if lte IE 6]>
<link rel="stylesheet" type="text/css" href="/sites/all/themes/asuzen/ie6.css" />
<![endif]-->
<!--[if gte IE 7]>
<link rel="stylesheet" type="text/css" href="/sites/all/themes/asuzen/ie7.css" />
<![endif]-->
<!--[if IE 8]>
<link rel="stylesheet" type="text/css" href="/sites/all/themes/asuzen/ie8.css" />
<![endif]-->


</head>
<body class="not-front not-logged-in node-type-page one-sidebar sidebar-left page-welcome-html section-welcome-html">

	<!-- START skip links -->
	<ul class="skip">
	<li><a href="#main">Skip to content</a></li>
	<li><a href="#sidebar-right">Skip to navigation</a></li>
		<!-- Including a site map is especially helpful to users dependent on assistive technology.
		To create a quick sitemap, download the Sitemap Module ( http://drupal.org/project/site_map ); install the module in your folder /sites/all/modules (create folder if necessary); and enable it in http://YourSite.asu.edu/admin/build/modules. Then uncomment the link below. That's it! -->
	<!-- <li><a href="/sitemap">Skip to site map page</a></li> -->
	</ul>
	<!-- /.skip links -->

<div class="asu_set_fixed_width">


<!-- START #asu_container -->  	
<div id="asu_container">

<div>
<table>
<tr>
<td>
   <center>
   <img src="images/webpage1.jpg" alt="NA" height="250"></a>
   </center>
</td>
</tr>
</table>

</div><!-- end gold header-->  
   


<!-- START main -->

<div id="main"><div id="main-inner" class="clear-block with-navbar">
<div id="content"><div id="content-inner"><div id="content-header">

</div> <!-- /#content-header -->
 	
<div id="content-area">
<div id="node-484" class="node node-type-page"><div class="node-inner">

  
<div class="content">
<h2>
<br>
<br>
<a href="CRCNS2014_Abstracts.pdf">Click here to see all abstracts for the meeting.</a></h3>

</div>

  
</div></div> <!-- /node-inner, /node -->
	  </div>

	  
	  
    </div></div> <!-- /#content-inner, /#content -->

       
        <div id="sidebar-left"><div id="sidebar-left-inner" class="region region-left">
        	<!-- START name-and-slogan -->
			
			<!-- /#name and slogan -->

        <div id="block-menu-primary-links" class="block block-menu region-odd odd region-count-1 count-1"><div class="block-inner">

  
  <div class="content">

    <ul class="menu">
<li class="leaf"><a href="index.html" class="active">Home</a></li><br>
<li class="leaf"><a href="Register.html" class="active">Register</a></li><br>
<li class="leaf"><a href="Workshops.html" class="active">Workshops</a></li><br>
<li class="leaf"><a href="Main_Meeting.html" class="active">Main Meeting</a></li><br>
<li class="leaf"><a href="Travel.html" class="active" >Travel</a></li><br>
<li class="leaf"><a href="Hotel.html" class="active">Hotel</a></li><br>
<li class="leaf"><a href="Restaurants.html" class="active">Restaurants</a></li><br>
<li class="leaf"><a href="Family_Info.html" class="active">Family Info</a></li><br>
<li class="leaf"><u>View Abstracts</u></li><br>


</ul>  </div>

  

</div></div> <!-- /block-inner, /block -->
        </div></div> <!-- /#sidebar-left-inner, /#sidebar-left -->
      
      
    </div></div> <!-- /#main-inner, /#main -->

	   <!-- START FOOTER /asuthemes/2.0/includes/html/asu_footer.shtml -->   
   <!-- END FOOTER -->
	
</div><!-- /#asu-container -->

</div><!-- /.asu_set_fixed_width -->

  

   <!-- Begin ASU Google Analytics code -->

   <script type="text/javascript">
     var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
     document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
   </script>
    
   <script type="text/javascript">
     var pageTracker = _gat._getTracker("UA-2392647-1");
     pageTracker._setDomainName("asu.edu");
     pageTracker._initData();
     pageTracker._trackPageview();
   </script>
   <!-- End ASU Google Analytics code -->
</body>
<script language='JavaScript' type='text/javascript'>
function refreshCaptcha()
{
	var img = document.images['captchaimg'];
	img.src = img.src.substring(0,img.src.lastIndexOf("?"))+"?rand="+Math.random()*1000;
}
</script>
</html>


