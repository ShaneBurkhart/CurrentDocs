Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.subscribe 'customer.subscription.deleted' do |event|
  user = User.find_by_customer_id(event.data.object.customer)
  user.expire if user
end
