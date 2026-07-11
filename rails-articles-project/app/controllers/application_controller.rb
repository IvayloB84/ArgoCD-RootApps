# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern web browsers supporting webp images, web push, badges, import maps.
  allow_browser versions: :modern

  # FIXED: Allows anonymous guests to fetch uploaded picture files globally
  allow_unauthenticated_access if: -> { request.path.start_with?("/rails/active_storage") || params[:controller]&.start_with?("active_storage/") }
end
