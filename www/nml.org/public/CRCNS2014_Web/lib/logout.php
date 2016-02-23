<HTML>
<head>
<?php include "lib/head.html"?>
<div id="mathimage" align="center">
<Title>Logout</Title>
<h3>The reference letter has been uploaded successfuly, Thank you.</h3>
</div>
</HTML>

<?php
session_unset();
session_destroy();
//header("location:www.math.asu.edu");
?>
