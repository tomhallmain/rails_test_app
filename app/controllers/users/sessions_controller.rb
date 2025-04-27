class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: "Signed in successfully.", user: resource }, status: :ok
  end

  def respond_to_on_destroy
    render json: { message: "Signed out successfully." }, status: :ok
  end
end 