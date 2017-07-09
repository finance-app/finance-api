class ApplicationController < ActionController::API
  include Knock::Authenticable
  before_action :set_paper_trail_whodunnit, :authenticate_user
  before_action :refresh_bearer_auth_header, if: :bearer_auth_header_present

  private

    def bearer_auth_header_present
      request.env["HTTP_AUTHORIZATION"] =~ /Bearer/
    end

    def refresh_bearer_auth_header
      authenticate_user

      if current_user
        headers['Authorization'] = Knock::AuthToken.new(payload: { sub: current_user.id }).token
      end
    end
end
