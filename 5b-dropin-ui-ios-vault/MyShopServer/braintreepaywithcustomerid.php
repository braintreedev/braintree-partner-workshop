<?php

include './braintree-php/lib/Braintree.php';

Braintree_Configuration::environment('sandbox');
Braintree_Configuration::merchantId('mfx4wrcgnhjpqgtw');
Braintree_Configuration::publicKey('s2rdn7zhdvn7fz9b');
Braintree_Configuration::privateKey('75c15e64858c6cc3cb00c18c6dbaaa07');

$nonce = $_POST["payment_method_nonce"];
$customerid = $_POST["customerid"];

$file = 'log.txt';
$current = $customerid."   ".$nonce;

$result = Braintree_Transaction::sale([
  'amount' => '99.00',
  'paymentMethodNonce' => $nonce,
  'customerId' => $customerid
]);

$current .= "   ".$result;

file_put_contents($file, $current);

echo($result);

?>
