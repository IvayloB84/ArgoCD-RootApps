# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  # Allow unauthenticated users to view the login screen layout
  allow_unauthenticated_access only: [ :new, :create ]
  
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Too many sign-in attempts. Try again later." }

  def new
  end

  def create
    # FIXED: Find users by your custom username attribute field parameter mapping
    if user = User.authenticate_by(username: params[:username], password: params[:password])
      start_new_session_for user
      redirect_to articles_path, notice: "Signed in successfully!"
    else
      redirect_to new_session_url, alert: "Invalid username or password credentials."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_url, notice: "Signed out successfully."
  end
end