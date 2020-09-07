class ChargesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :load_square_service

  def charge_card

    # To learn more about splitting payments with additional recipients,
    # see the Payments API documentation on our [developer site]
    # (https://developer.squareup.com/docs/payments-api/overview).
    # Charge 1 dollar (100 cent)

    customer_id = 'T9J0ZR0PG4W8BC9KF5QCYV7JJM'
    source_id = ''
    if params[:nonce].empty?
    	source_id = params[:card_nonce]
    elsif params[:add_card] == 'on'
      card = @sq_service.create_card(customer_id, params[:nonce])
      source_id = card.fetch(:id)
    else
      source_id = params[:nonce]
    end

    resp = @sq_service.process_payment(source_id, customer_id, params[:amount].to_f)

    if resp.success?
      @payment = resp.data.payment
    else
      @error = resp.errors
    end
  end

  def refund
    response = @sq_service.refund(params[:refund_amount], params[:payment_id])
    if response.success?
      response.data.customer
    elsif response.error?
      response.errors
    end
  end

  private

  def load_square_service
  	@sq_service = SquarePaymentService.new
  end
end
