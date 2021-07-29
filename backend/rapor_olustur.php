<?php

// rapor_olustur.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\Rapor;
use Src\User;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$rapor = new Rapor($conn);
$user= new User($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("rapor_olustur.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);


$user_ik = $user->findByRole(6); // ik rolü olan kullanıcıyı bul


$rapor_data = array(
    "kullanici_id" => $jsoninput_array['data']['id'],
    "rapor_tarihi"          => date("Y-m-d"),
    "nedeni"       => $jsoninput_array['data']['rapor_nedeni'],
    "rapor_baslangic"        => $jsoninput_array['data']['rapor_baslangic'],
    "rapor_bitis"       => $jsoninput_array['data']['rapor_bitis'],
    "durum_id"        => 1,
    "bekler_id" => $user_ik[0]['kullanici_id']
);

$result = $rapor->insert($rapor_data);

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
    echo json_encode($response, JSON_NUMERIC_CHECK);
}