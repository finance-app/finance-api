require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get accounts" do
    get accounts_url, headers: authenticated_header
    assert_response :success
  end

  test "should get account" do
    get accounts_url, params: { id: 1 }, headers: authenticated_header
    assert_response :success
  end
end
