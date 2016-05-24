Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by stripe_id: event.data.object.customer
    Payment.create user: user, amount: event.data.object.amount, reference_id: event.data.object.id, currency: event.data.object.currency
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by stripe_id: event.data.object.customer
    user.deactivate!
  end
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
