# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern web browsers supporting webp images, web push, badges, import maps.
  allow_browser versions: :modern
end