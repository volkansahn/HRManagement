<?php

// bekleyen_rapor.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\Rapor;
use Src\User;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$rapor = new Rapor($conn);
$user = new User($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

// logging
$myfile = fopen("bekleyen_rapor.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$raporlar = $rapor->findBekler($jsoninput_array['kullanici_id']);

$bekleyen_rapor_list = array();

for ($i=0 ; $i < count($raporlar) ; $i++) {

    $user_data = $user->find($raporlar[$i]['kullanici_id']);

    if ($raporlar) {
        $rapor_data = array(
            "adi" => $user_data[0]["adi"],
            "soyadi" => $user_data[0]["soyadi"],
            "izin_id" => $raporlar[$i]['rapor_id'],
            "nedeni" => $raporlar[$i]['nedeni'],
            "rapor_baslangic" => $raporlar[$i]['rapor_baslangic'],
            "rapor_bitis" => $raporlar[$i]['rapor_bitis'],
            "durum_id" => $raporlar[$i]['durum_id'],
            "bekler_id" => $raporlar[$i]['bekler_id']
        );
    }

    array_push($bekleyen_rapor_list, $rapor_data);
}


if ($raporlar) {
    $response = array(
        "is_success" => true,
        "messages" => "Success",
        "data" => $bekleyen_rapor_list
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
}