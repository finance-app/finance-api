require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: 1 }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  # This line should be uncommented if there is a need to seed test database
  #Rails.application.load_seed
end
