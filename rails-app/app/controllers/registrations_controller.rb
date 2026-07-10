# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  # FIXED: Grants explicit public access to the sign-up form and account generation loops!
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      start_new_session_for @user
      redirect_to articles_path, notice: "Account created successfully! Welcome aboard."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def registration_params
      params.require(:user).permit(:username, :password, :password_confirmation, :date_of_birth, :email_address)
  end
end