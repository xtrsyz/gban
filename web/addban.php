<?php
session_start();
include('database.php');

if ($_POST['ban'] ) {
	if ($_POST['reason']) {
		$reason = $_POST['reason'];
	} else {
		$reason = "Banned by Staff";
	}
	$identifier = $_REQUEST['ban'];
	$result = mysqli_query($conn,"INSERT INTO `banlist` (`identifier`, `reason`) VALUES ('$identifier', '$reason');");
	$banmessage="<div class='alert alert-success' id='ban'>". $identifier ." has been banned!</div>";
}