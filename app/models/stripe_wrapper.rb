module StripeWrapper
  module Responsable
    def initialize(response, status)
      @response = response
      @status = status
    end

    def successful?
      status == :successful
    end

    def error_message
      response.message
    end
  end

  class Charge
    include Responsable

    attr_reader :response, :status

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          :source  => options[:source],
          :amount      => options[:amount],
          :description => options[:description],
          :currency    => 'usd'
        )
        new(response, :successful)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end
  end

  class Customer
    include Responsable

    attr_reader :response, :status, :customer_id

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          :source  => options[:source],
          :plan => options[:plan],
          :email => options[:email],
          :description => options[:description],
        )
        new(response, :successful)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end
  end
end
