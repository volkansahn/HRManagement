<?php

// login.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\User;
use Src\Maas;
use Src\Role;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$user = new User($conn);
$maas = new Maas($conn);
$role = new Role($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

$myfile = fopen("login.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$user_data = array(
    "kullanici_id" => $jsoninput_array['kullanici_id'],
    "sifre" => $jsoninput_array['sifre']
);

$match = $user->find($user_data["kullanici_id"]);
$maas_bilgisi = $maas->find($user_data["kullanici_id"]);
$rol_bilgisi = $role->find($match[0]['rol_id']);

if ($match[0]['sifre'] == $user_data["sifre"]) {
    $result = true;
} else {
    $result = false;
}

$data = array(
    "id" => $match[0]['kullanici_id'],
    "authToken" => "auth_will_be_genereted",
    "isim"=> $match[0]['adi'],
    "soyisim"=> $match[0]['soyadi'],
    "rol" => $rol_bilgisi[0]['rol'],
    "bazMaas" => $maas_bilgisi[0]['maas'],
    "yanOdeme" => $maas_bilgisi[0]['yan_odemeler']
);

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Login Success",
        "data" => $data
    );
    echo json_encode($response, JSON_NUMERIC_CHECK);
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Login Failed"
    );
    echo json_encode($response,JSON_NUMERIC_CHECK);;
}