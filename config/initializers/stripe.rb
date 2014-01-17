Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.subscribe 'customer.subscription.deleted' do |event|
  puts "=" * 100
  puts "Stripe: Subscription was ended."
  puts "=" * 100
  puts event
  puts "=" * 100
  user = User.find_by_stripe_customer_id(event.data.object.customer)
  user.expire if user
end
