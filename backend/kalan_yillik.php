<?php

// kalan_yillik.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\İzinler;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$izinler = new İzinler($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("kalan_yillik.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$user_data = array(
    "kullanici_id" => $jsoninput_array['kullanici_id'],
    "auth_token" => $jsoninput_array['auth_token']
);

$match = $izinler->find($user_data["kullanici_id"]);

if (isset($match)) {
    $result = true;
} else {
    $result = false;
}

$data = array(
    "kalan_yillik_izin" => $match[0]['kalan_yillik_izin']
);

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success",
        "data" => $data
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response,JSON_NUMERIC_CHECK);
}