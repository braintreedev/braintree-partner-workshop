require "sinatra"
require 'braintree'

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = 'ffdqc9fyffn7yn2j'
Braintree::Configuration.public_key = 'qj65nndbnn6qyjkp'
Braintree::Configuration.private_key = 'a3de3bb7dddf68ed3c33f4eb6d9579ca'

get "/" do
  @client_token = Braintree::ClientToken.generate
  erb :index
end

post "/process" do
  result = Braintree::Transaction.sale({
    payment_method_nonce: params[:payment_method_nonce],
    amount: 20
  });

  if result.success?
    "Success! Transaction ID: #{result.transaction.id}"
  else
    "Ruh roh?!"
  end
end
