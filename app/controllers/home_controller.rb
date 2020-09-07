class HomeController < ApplicationController
  def index

    # payments_api = api_client.payments
    # @payments = payments_api.list_payments()

    customer_id = 'T9J0ZR0PG4W8BC9KF5QCYV7JJM'
    customers_api = client.customers
    customer_response = customers_api.retrieve_customer(customer_id: customer_id)
    @cards = customer_response.data.customer.fetch(:cards)
    @payments = client.payments.list_payments
  end

  private

  def client
    api_client = Square::Client.new(
      access_token: Rails.application.secrets.square_access_token,
      environment: ENV['IS_PRODUCTION'] == 'false' ? 'sandbox' : 'production'
    )
  end
end
