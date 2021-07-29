<?php

// izin_onayla.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\İzin_Talebi;
use Src\İzinler;
use Src\User;


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$izin_talebi = new İzin_Talebi($conn);
$user = new User($conn);
$izinler = new İzinler($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("izin_onayla.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$kullanici_id = $jsoninput_array['kullanici_id'];
$izin_id = $jsoninput_array['data']['izin_id'];

$izin_talebi_data = $izin_talebi->find($izin_id);
$izin_turu = strtolower($izin_talebi_data[0]['izin_turu']); // izin türününü bul
$izin_sahibi = $izin_talebi_data[0]['kullanici_id']; // izin sahibini bul

$user_data = $user->find($kullanici_id); // istek yapan kullanıcı bilgilerini bul
$user_ik = $user->findByRole(6); // ik rolü olan kullanıcıyı bul
$kalan_izinler = $izinler->find($izin_sahibi);

$izin_baslangic = new DateTime($izin_talebi_data[0]['izin_baslangic']);
$izin_bitis = new DateTime($izin_talebi_data[0]['izin_bitis']);
$interval = (array) $izin_baslangic->diff($izin_bitis);
$izin_gun = $interval['days'];

if ($user_data[0]['rol_id'] == 9) { // if role is amir
    $durum_id = 1;
    $bekler_id = $user_ik[0]['kullanici_id'];
} elseif ($user_data[0]['rol_id'] == 6) { // if role is ik
    $durum_id = 3;
    $bekler_id = null;
    if ($izin_turu == "yillik") {
        $kalan = $kalan_izinler[0]['kalan_yillik_izin'] - $izin_gun;
        $izinler->updateYillik($izin_sahibi, $kalan);
    } elseif ($izin_turu == "mazeret") {
        $kalan = $kalan_izinler[0]['kalan_mazaret_izin'] - $izin_gun;
        $izinler->updateMazaret($izin_sahibi, $kalan);
    }
}

$izin_data = array(
    "izin_id" => $izin_id,
    "durum_id" => $durum_id,
    "bekler_id" => $bekler_id
);

$result = $izin_talebi->updateOnay($izin_data);

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