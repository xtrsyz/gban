<?php
session_start();
include('database.php');

$data = json_decode(file_get_contents("php://input"), true);
if ($data) {
	$identifier = json_decode($data['identifier'], true);
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