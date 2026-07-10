# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  # Allow anyone to access the registration screen without being logged in
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      # Automatically log in the user upon successful registration
      start_new_session_for @user
      redirect_to articles_path, notice: "Account created successfully! Welcome aboard."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def registration_params
      # Whitelisting your exactly 3 required parameters
      params.require(:user).permit(:username, :password, :date_of_birth, :email_address)
    end
end