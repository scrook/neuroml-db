<?php
//Config.php
//Database configuration file.
$mysql_hostname = "localhost";
$mysql_user = "crcns";
$mysql_password = "!crcns)";
$mysql_database = "CRCNS";
$bd = mysql_connect($mysql_hostname, $mysql_user, $mysql_password) 
or die("Opps some thing went wrong");
mysql_select_db($mysql_database, $bd) or die("Opps some thing went wrong");
?>
