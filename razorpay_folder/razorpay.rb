require "razorpay"
require 'json'
require 'erb'
require 'execjs'
require 'sinatra'


Razorpay.setup('rzp_test_GeMC7nLMOAnW3c', 'R61yIBr3cp1iJbKQz79ubj9T')
options = Razorpay::Order.create amount: 500, currency: 'INR', receipt: 'TEST'
b=JSON.pretty_generate(options)

@order_id = JSON.parse(b)["id"]

get '/' do
    redirect ("/order")
end
get '/order' do
    redirect ("/payments")
end
get '/payments' do
    erb :payments
end

post '/payment' do
    # paymentId = params[:razorpay_payment_id]
    data = {
        :razorpay_payment_id => params[:razorpay_payment_id],
        :razorpay_order_id => params[:razorpay_order_id],
        :razorpay_signature => params[:razorpay_signature]
    }
    return data.to_json
end

get('/payment') do
    "This will be our home page.  is always the root route in a Sinatra application."
end
