<?php
include('config.php');
session_start();
$user_check=$_SESSION['login_user'];
$ses_sql=mysql_query("select username from table_apl_reviewers where username='$user_check' ");
$row=mysql_fetch_array($ses_sql);
$login_session=$row['username'];
if(!isset($login_session))
{
	header("Location: index.php");
}
?>
