class Shop::Stripe::StripeController < ApplicationController
  before_action :set_stripe_key

  private

    def set_stripe_key
      Stripe.api_key = Rails.application.config.stripe[:secret_key]
    end

end
