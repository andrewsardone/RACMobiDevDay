require 'rubygems'
require 'sinatra'
require 'andand'
require 'json'

accounts = {}

before '/*' do
  content_type :json
end

get '/accounts' do
  accounts.values.sort { |l, r| l[:id] <=> r[:id] }.to_json
end

post '/accounts' do
  sleep 3 # simulate slower network connection

  first_name = params["first_name"]
  last_name = params["last_name"]
  email = params["email"].andand.downcase

  halt 400, error_reason("Please provide first name, last name, and email") unless first_name && last_name && email

  acct = accounts[email]
  halt 409, error_reason("Account already exists") if acct

  status 201
  accounts[email] = {
    :id => accounts.count + 1,
    :first_name => first_name,
    :last_name => last_name,
    :email => email,
  }
  accounts[email].to_json
end

def error_reason(msg)
  { "error" => msg }.to_json
end
