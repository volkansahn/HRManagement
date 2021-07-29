<?php

// calisan_bilgi.php

require 'vendor/autoload.php';
use Src\DatabaseConnector;
use Src\User;
use Src\Amir;

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$conn = (new DatabaseConnector())->getConnection();
$user = new User($conn);
$amir = new Amir($conn);

// data coming from iOS
$jsoninput = file_get_contents('php://input');
$jsoninput_array = json_decode($jsoninput,true);

// logging
$myfile = fopen("calisan_bilgi.txt", "a") or die("Unable to open file!");
$txt = "\n";
fwrite($myfile, $jsoninput);
fwrite($myfile, $txt);
fclose($myfile);

$user_data = array(
    "kullanici_id" => $jsoninput_array['data']['calisan_id'],
);

$match = $user->find($user_data['kullanici_id']);

$amir_data = $amir->findAmir($user_data['kullanici_id']);
if ($amir_data) {
    $amir_user = $user->find($amir_data[0]['amir_id']);
    $match[0]['amir_adi'] = $amir_user[0]['adi'];
    $match[0]['amir_soyadi'] = $amir_user[0]['soyadi'];
} else {
    $match[0]['amir_adi'] = null;
    $match[0]['amir_soyadi'] = null;
}




if (isset($match)) {
    $result = true;
} else {
    $result = false;
}

if ($result) {
    $response = array(
        "is_success" => true,
        "messages" => "Success",
        "data" => $match[0]
    );
    echo json_encode($response);;
} else {
    $response = array(
        "is_success" => false,
        "messages" => "Failed"
    );
    echo json_encode($response);;
}