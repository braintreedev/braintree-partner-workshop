<?php

include './braintree-php/lib/Braintree.php';

Braintree_Configuration::environment('sandbox');
Braintree_Configuration::merchantId('mfx4wrcgnhjpqgtw');
Braintree_Configuration::publicKey('s2rdn7zhdvn7fz9b');
Braintree_Configuration::privateKey('75c15e64858c6cc3cb00c18c6dbaaa07');

echo($clientToken = Braintree_ClientToken::generate());
?>
