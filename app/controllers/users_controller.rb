class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    # The profile view will use current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path, notice: 'Profile was successfully updated.'
    else
      render :profile, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end 