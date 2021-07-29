<?php

// calisan_sil.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\User;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$user = new User($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("calisan_sil.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$user_data = array(
    "kullanici_id" => $jsoninput_array['data']['calisan_id']
);

$result = $user->delete($user_data["kullanici_id"]);

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success"
    );
    echo json_encode($response);;
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response);;
}