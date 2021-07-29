<?php

// rapor_onayla.php

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

$myfile = fopen("rapor_onayla.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$kullanici_id = $jsoninput_array['kullanici_id'];
$rapor_id = $jsoninput_array['data']['rapor_id'];
$user_data = $user->find($kullanici_id); // istek yapan kullanıcı bilgilerini bul
$user_ik = $user->findByRole(6); // ik rolü olan kullanıcıyı bul

/*
if ($user_data[0]['rol_id'] == 9) { // if role is amir
    $durum_id = 1;
    $bekler_id = $user_ik[0]['kullanici_id'];
} elseif ($user_data[0]['rol_id'] == 6) { // if role is ik
    $durum_id = 3;
    $bekler_id = null;
}

{
    "kullanici_id" : "k1999",
    "auth_token" : "asdgfas",
    "data" : {
        "rapor_id" : 7
    }
}

{
    "kullanici_id" : "k1234",
    "auth_token" : "asdgfas",
    "data" : {
        "id" : "k1234",
      	"rapor_tarihi" : "2021-01-01",
      	"rapor_nedeni" : "hapsirik",
      "rapor_baslangic" : "2021-01-01",
      "rapor_bitis" : "2021-02-02"
    }
}

*/

$durum_id = 3;
$bekler_id = null;

$izin_data = array(
    "durum_id" => $durum_id,
    "rapor_id" => $rapor_id,
    "bekler_id" => $bekler_id
);

$result = $rapor->updateOnay($izin_data);


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