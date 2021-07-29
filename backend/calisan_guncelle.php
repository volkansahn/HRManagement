<?php

// calisan_guncelle.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\User;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$user = new User($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

// logging
$myfile = fopen("calisan_guncelle.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$user_data = array(
    "kullanici_id" => $jsoninput_array['data']['id'],
    "adi"          => $jsoninput_array['data']['isim'],
    "soyadi"       => $jsoninput_array['data']['soyisim'],
    "rol_id"       => $jsoninput_array['data']['rol']
);

$result = $user->update($user_data["kullanici_id"],$user_data);

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success"
    );
    echo json_encode($response);;
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response);;
}