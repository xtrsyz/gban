<?php
$servername = "localhost";
$username = "fivem";
$password = "pas5w0rd";
$db = "fivem";

$conn = mysqli_connect($servername, $username, $password,$db);

if (!$conn) {
	die("Connection failed: " . mysqli_connect_error());
}
