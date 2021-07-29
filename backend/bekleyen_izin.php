<?php

// bekleyen_izin.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\İzin_Talebi;
use Src\User;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$izin_talebi = new İzin_Talebi($conn);
$user = new User($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

// logging
$myfile = fopen("bekleyen_izin.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$izin = $izin_talebi->findBekler($jsoninput_array['kullanici_id']);

$bekleyen_izin_list = array();

for ($i=0 ; $i < count($izin) ; $i++) {

    $user_data = $user->find($izin[$i]['kullanici_id']);

    if ($izin) {
        $izin_data = array(
            "adi" => $user_data[0]["adi"],
            "soyadi" => $user_data[0]["soyadi"],
            "izin_id" => $izin[$i]['izin_id'],
            "izin_turu" => $izin[$i]['izin_turu'],
            "izin_baslangic" => $izin[$i]['izin_baslangic'],
            "izin_bitis" => $izin[$i]['izin_bitis'],
            "durum_id" => $izin[$i]['durum_id'],
            "bekler_id" => $izin[$i]['bekler_id']
        );
    }

    array_push($bekleyen_izin_list, $izin_data);
}


if ($izin) {
    $response = array(
        "is_success" => true,
        "messages" => "Success",
        "data" => $bekleyen_izin_list
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
}