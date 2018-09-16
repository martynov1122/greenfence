require 'stripe'

class PaymentServices < Services

    # from and to => token, extras => hash
    def initialize(source, destination, amount, extras = {})
      @source = source
      @destination = destination
      @amount = amount
      @fee = SystemSetting.find_by_key('application_fee').value.to_i
      @extras = extras
    end

    def charge
      # Set your secret key: remember to change this to your live secret key in production
      # See your keys here https://dashboard.stripe.com/account/apikeys
      # stripe api key change
      Stripe.api_key = ENV['STRIPE_CLIENT_SECRET_KEY']  

      # Create the charge on Stripe's servers - this will charge the user's card
      begin
        if @source.blank? || @destination.blank? || @amount.blank?
          raise "payment requires source, destination and amount!"
        end
        charge = Stripe::Charge.create(
          :amount => (@amount*100).to_i, # amount in cents, again
          :currency => "usd",
          :source => @source,
          :application_fee => (@amount*@fee).to_i,
          :description => "Greenfence Inc.",
          :destination => @destination # auditor stripe account id
        )
        save_payment_record()
      rescue Stripe::CardError => e
        # The card has been declined
      end
    end

    private
    def save_payment_record
      payment = Payment.create!(from_user: @extras[:from], to_user: @extras[:to], amount: @amount, currency: 'usd', payable_id: @extras[:payable].id, payable_type: @extras[:payable].class.to_s, payment_time: Time.zone.now)
    end

end