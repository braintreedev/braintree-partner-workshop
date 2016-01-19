require "sinatra"
require 'braintree'

enable :sessions

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = 'ffdqc9fyffn7yn2j'
Braintree::Configuration.public_key = 'qj65nndbnn6qyjkp'
Braintree::Configuration.private_key = 'a3de3bb7dddf68ed3c33f4eb6d9579ca'

get "/" do
  @client_token = Braintree::ClientToken.generate({
    customer_id: customer_id
    })
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

def customer_id
  return session[:customer_id] if session[:customer_id] != nil
  result = Braintree::Customer.create(
    :first_name => "Jen",
    :last_name => "Smith",
    :company => "Braintree",
    :email => "jen@example.com",
    :phone => "312.555.1234",
    :fax => "614.555.5678",
    :website => "www.example.com"
  )
  if result.success?
    session[:customer_id] = result.customer.id
    return session[:customer_id]
  else
    "Could not create the customer"
  end
end
