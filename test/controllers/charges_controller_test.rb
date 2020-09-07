require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get charge_card" do
    get charges_charge_card_url
    assert_response :success
  end

end
