<?php
header('Content-Type: text/html');
{
  $country = $_POST['Code'];
  $number = $_POST['Number'];
  $method = $_POST['Method'];

  $data['info'] = array();

  $data['info'][] = array(
    'country' => $country,
    'number' => $number,
    'method' => $method;

  $jdata = json_encode($data);

  $f = fopen('result.txt', 'w+');
  fwrite($f, $jdata);
  fclose($f);
}
?>