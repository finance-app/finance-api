require 'test_helper'

class TargetsControllerTest < ActionDispatch::IntegrationTest
  test "should get targets" do
    get targets_url, headers: authenticated_header
    assert_response :success
  end

  test "should get target" do
    get targets_url, params: { id: 1 }, headers: authenticated_header
    assert_response :success
  end
end
