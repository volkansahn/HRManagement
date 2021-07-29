<?php

// izin_talebi.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\İzin_Talebi;
use Src\Amir;


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$izin_talebi = new İzin_Talebi($conn);
$amir= new Amir($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("izin_talebi.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

/*
if ($jsoninput_array['data']['izin_turu']) {
    $izin_turu = "yillik";
} else {
    $izin_turu = "mazaret";
}
*/

$amir = $amir->findAmir($jsoninput_array['data']['id']);

if (!$amir) {
    $amir[0]['amir_id'] = null;
}

$izin_data = array(
    "kullanici_id" => $jsoninput_array['data']['id'],
    "izin_turu"       => $jsoninput_array['data']['izin_turu'],
    "izin_baslangic"        => $jsoninput_array['data']['izin_baslangic'],
    "izin_bitis"       => $jsoninput_array['data']['izin_bitis'],
    "durum_id" => 1,
    "bekler_id" => $amir[0]['amir_id']
);

$result = $izin_talebi->insert($izin_data);


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