Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.subscribe 'customer.subscription.deleted' do |event|
  user = User.find_by_customer_id(event.data.object.customer)
  user.expire if user
end
