<?php
switch ($_SERVER['REQUEST_METHOD']) {
	case 'GET':
		switch ($_GET['query']) {
			case 'version':
				$server_port = trim(file_get_contents("/var/run/apache2/server_port"));
				$result = shell_exec("mc-monitor status --host localhost --port $server_port --timeout 3s | awk '{ print \$3 }' | awk -F'=' '{ print \$2 }'");
				if ($result === false || is_null($result))
					$response = array('status' => 'error', 'error' => 'Version query command failed or returned empty');
				else
					$response = array('status' => 'success', 'response' => trim($result));
				break;
			case 'status':
				$output = null;
				$retcode = null;
				$result = exec("ps -ax -o stat,comm", $output, $retcode);
				if ($result === false || $retcode != 0)
					$response = array('status' => 'error', 'error' => 'Status query command failed');
				foreach ($output as $line) {
					if (strpos($line, 'java')) {
						if ($line[0] == 'S') {
							$server_port = trim(file_get_contents("/var/run/apache2/server_port"));
							$result = shell_exec("mc-monitor status --host localhost --port $server_port --timeout 3s");
							if ($result === false || is_null($result))
								$response = array('status' => 'success', 'response' => 'Starting');
							else
								$response = array('status' => 'success', 'response' => 'Up');
						}
						elseif ($line[0] == 'T') {
							$response = array('status' => 'success', 'response' => 'Paused');
						}
						else {
							$response = array('status' => 'error', 'error' => 'Could not determine java process state');
						}
						break;
					}
				}
				if (!isset($response))
					$response = array('status' => 'success', 'response' => 'Down');
				break;
			case 'command_result':
				if (file_exists("/var/run/apache2/command_result")) {
					$result=file_get_contents("/var/run/apache2/command_result");
					if ($result == "success")
						$response = array('status' => 'success');					
					else
						$response = array('status' => 'error', 'error' => $result);
					unlink("/var/run/apache2/command_result");
				}
				else {
					$response = array('status' => 'pending');
				}
				break;
			default:
				$response = array('status' => 'error', 'error' => 'Invalid query');
		}
		break;

	case 'POST':
		if (file_exists("/var/run/apache2/command")) {
			$response = array('status' => 'error', 'error' => 'Command already queued');
		}
		else {
			switch ($_POST['command']) {
				case 'Start':
				case 'Stop':
				case 'Restart':
				case 'Pause':
				case 'Resume':
				case 'Update':
					file_put_contents("/var/run/apache2/command", $_POST['command']);
					$response = array('status' => 'success', 'command' => $_POST['command']);
					break;
				default:
					$response = array('status' => 'error', 'error' => 'Invalid command: ' . $_POST['command']);
			}
		}
		break;
	default:
		$response = array('status' => 'error', 'error' => 'Invalid request method');
}
header('Content-type: application/json');
echo json_encode($response);
?>