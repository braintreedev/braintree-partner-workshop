<?php

include './braintree-php/lib/Braintree.php';

Braintree_Configuration::environment('sandbox');
Braintree_Configuration::merchantId('mfx4wrcgnhjpqgtw');
Braintree_Configuration::publicKey('s2rdn7zhdvn7fz9b');
Braintree_Configuration::privateKey('75c15e64858c6cc3cb00c18c6dbaaa07');

$result = Braintree_Customer::create([
    'firstName' => 'Mike',
    'lastName' => 'Jones',
    'company' => 'Jones Co.',
    'email' => 'mike.jones@example.com',
    'phone' => '281.330.8004',
    'fax' => '419.555.1235',
    'website' => 'http://example.com'
]);

if ($result->success)
{
//  $result->customer->id;
  echo($result->customer->id);
}
else
{
  echo ('0');
}

?>
