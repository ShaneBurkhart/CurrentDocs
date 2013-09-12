class Subscription < ActiveRecord::Base
  attr_accessible :address, :address_2, :city,
    :name, :state, :stripe_customer_id, :user_id, :zipcode
  belongs_to :user
  validates :address, :city, :name, :state, :user_id, :zipcode, presence: true
  validate :customer_creation

  attr_accessor :stripe_card_token

  def save_with_stripe
    if !self.stripe_card_token.blank?
      customer = Stripe::Customer.create email: self.user.email,
        plan: "manager", card: self.stripe_card_token
      self.stripe_customer_id = customer.id
      puts "Call"
    end
    save! if valid?
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  private

    def customer_creation
      errors.add(:card, "had an error when validating.") if self.stripe_customer_id.blank?
    end
end
