<?php

// calisan_olustur.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\User;
use Src\Maas;


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$user = new User($conn);
$maas = new Maas($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

// logging
$myfile = fopen("calisan_olustur.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$user_data = array(
    "kullanici_id" => $jsoninput_array['data']['id'],
    "adi"          => $jsoninput_array['data']['isim'],
    "soyadi"       => $jsoninput_array['data']['soyisim'],
    "sifre"        => $jsoninput_array['data']['sifre'],
    "rol_id"       => $jsoninput_array['data']['rol']
);

$result = $user->insert($user_data);

$maas_data = array(
    'maas' => null,
    'yan_odemeler' => null,
    'kullanici_id' => $user_data['kullanici_id']
);

$maas_bigisi =  $maas->insert($maas_data);

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