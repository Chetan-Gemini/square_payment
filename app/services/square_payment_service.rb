class SquarePaymentService

  def initialize
    @client = square_api_client
  end

  def create_customer(name, email, phone)
    # Initialize refund API
    customers_api = @client.customers

    # You must provide at least one of the following values in your request to this endpoint:
    response = customers_api.create_customer(
                          body: { given_name: name,
                                  email_address: email,
                                  phone_number: phone })

    if response.success?
      response.data.customer
    elsif response.error?
      response.errors
    end
  end

  def find_customer(customer_id)
    # Initialize customer API
    customers_api = @client.customers
    
    response = customers_api.retrieve_customer(customer_id: customer_id)
    return nil if response.error?
    response.data.customer
  end

  def delete_customer(customer_id)
    # Initialize customer API
    customers_api = @client.customers

    response = customers_api.delete_customer(customer_id: customer_id)
    response.success?
  end

  # Card On File
  def create_card(customer_id, nonce)
    # Initialize customer API
    customers_api = @client.customers

    body = {}
    body[:card_nonce] = nonce # params[:nonce] 
    body[:billing_address] = {}
    body[:billing_address][:postal_code] = '94103' # 94103 must required for the Sandbox

    response = customers_api.create_customer_card(customer_id: customer_id, body: body)
    return nil if response.error?
    response.data.card
  end

  def process_payment(card_id = '', customer_id = '', amount = 0.0)
    request_body = {
      :autocomplete => true,
      :source_id => card_id,
      :customer_id => customer_id,
      :amount_money => {
        :amount => amount.to_f,
        :currency => 'USD'
      },
      :idempotency_key => SecureRandom.uuid
    }

    @client.payments.create_payment(body: request_body)
  end

  def refund(amount = 0.0, payment_id = '')
    # Initialize refund API
    refunds_api = @client.refunds

    request_body = {
      payment_id: payment_id,
      amount_money: {
        :amount => amount.to_f * 100,
        :currency => 'USD'
      },
      :idempotency_key => SecureRandom.uuid
    }
    
    refunds_api.refund_payment(body: request_body)
  end

  private

  def square_api_client
    # Create an instance of the API Client and initialize it with the credentials
    # for the Square account whose assets you want to manage.
    Square::Client.new(
      access_token: Rails.application.secrets.square_access_token,
      environment: ENV['IS_PRODUCTION'] == 'false' ? 'sandbox' : 'production'
    )
  end
end
