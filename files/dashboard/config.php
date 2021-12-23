<?php
$rconHost = "localhost";
$rconPort = trim(file_get_contents("/var/run/apache2/rcon_port"));
$rconPassword = trim(file_get_contents("/var/run/apache2/rcon_password"));
?>
