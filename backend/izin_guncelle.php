<?php

// izin_guncelle.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\İzinler;


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$izin = new İzinler($conn);


// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("izin_guncelle.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);


$izin_data = array(
    "kalan_mazaret_izin"       => $jsoninput_array['data']['mazeret_izni'],
    "kalan_yillik_izin"        => $jsoninput_array['data']['yıllık_izin']
);

$result = $izin->update($jsoninput_array['data']['calisan_id'],$izin_data);

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success"
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response,JSON_NUMERIC_CHECK);
}