module StripeWrapper
  class Charge
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end

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

    def successful?
      status == :successful
    end

    def error_message
      response.message
    end

  end
end
