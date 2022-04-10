<?php
session_start();
include('database.php');

if($_SERVER['CONTENT_TYPE'] === 'application/json') {
	$_POST = json_decode(file_get_contents('php://input'));
}

if ($_POST) {
	$identifier = json_decode($_POST['identifier'], true);
	$index = 0;
	$search = '';

	foreach ($identifier as $value) {
		if ($index > 0) {
			$search .= " OR identifier = '{$value}'";
		} else {
			$search = "'{$value}'";
		}
		$index++;
	}

	$result = mysqli_query($conn,"SELECT * FROM banlist WHERE identifier = $search AND `until` > NOW()");
	$response['status'] = 200;
	while ($row = mysqli_fetch_array($result)) {
		$response['reason'] = $row['reason'] . ' until ' . $row['until'];
	}

	print(json_encode($response));
}