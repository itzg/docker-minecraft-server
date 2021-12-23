<?php
header('Content-type: application/json');

require 'rcon.php';
require '../config.php';

$host = $rconHost;
$port = $rconPort;
$password = $rconPassword;
$timeout = 3;

$response = array();
$rcon = new Rcon($host, $port, $password, $timeout);

if(!isset($_POST['cmd'])){
  $response['status'] = 'error';
  $response['error'] = 'Empty command';
}
else{
  if ($rcon->connect()){
    $rcon->send_command($_POST['cmd']);
    $response['status'] = 'success';
    $response['command'] = $_POST['cmd'];
    $response['response'] = parseMinecraftColors($rcon->get_response());
  }
  else{
    $response['status'] = 'error';
    $response['error'] = 'RCON connection error';
  }
}

function parseMinecraftColors($string) {
  $string = utf8_decode(htmlspecialchars($string, ENT_QUOTES, "UTF-8"));
  $string = preg_replace('/\xA7([0-9a-f])/i', '<span class="mc-color mc-$1">', $string, -1, $count) . str_repeat("</span>", $count);
  return utf8_encode(preg_replace('/\xA7([k-or])/i', '<span class="mc-$1">', $string, -1, $count) . str_repeat("</span>", $count));
}

echo json_encode($response);
?>
