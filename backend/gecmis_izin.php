<?php

// gecmis_izin.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\İzin_Talebi;
use Src\Durum;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$izin_talebi = new İzin_Talebi($conn);
$durum = new Durum($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("gecmis_izin.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$result = $izin_talebi->findByUser($jsoninput_array['kullanici_id']);

$izin_list = array();

for ($i=0 ; $i < count($result) ; $i++ ) {
    $durum_adi = $durum->find($result[$i]["durum_id"])[0]["onay_durumu"];

    $izin_data = array(
        "izin_id" => $result[$i]["izin_id"],
        "kullanici_id" => $result[$i]["kullanici_id"],
        "izin_turu" => $result[$i]["izin_turu"],
        "izin_baslangic" => $result[$i]["izin_baslangic"],
        "izin_bitis" => $result[$i]["izin_bitis"],
        "durum" => $durum_adi,
        "bekler_id" => $result[$i]["durum_id"]
    );

    array_push($izin_list, $izin_data);
}

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success",
        "data" => $izin_list
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
}