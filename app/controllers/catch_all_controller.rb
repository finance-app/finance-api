class CatchAllController < ApplicationController
  before_action :authenticate_user

  def index
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end
end
