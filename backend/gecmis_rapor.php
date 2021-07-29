<?php

// gecmis_rapor.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\Rapor;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$rapor = new Rapor($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("gecmis_rapor.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);


$rapor_data = array(
    "kullanici_id" => $jsoninput_array['kullanici_id']
);

$result = $rapor->findByUser($jsoninput_array['kullanici_id']);


if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success",
        "data" => $result
    );
    fwrite($myfile, $txt);
    fwrite($myfile, json_encode($response, JSON_NUMERIC_CHECK));
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
}

fclose($myfile);