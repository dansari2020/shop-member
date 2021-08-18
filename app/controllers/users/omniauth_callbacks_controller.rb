class Users::OmniauthCallbacksController < ApplicationController
  require 'oauth2'

  def user_authorize
    redirect_to doorkeeper_oauth_client(ENV["DOORKEEPER_FRONTEND_APP_URL"]).auth_code.authorize_url(scope: "read")
  end

    # The OAuth callback
  def doorkeeper
    # Make a call to exchange the authorization_code for an access_token
    begin
      response = doorkeeper_oauth_client.auth_code.get_token(params[:code])
    
      # Extract the access token from the response
      token = response.to_hash[:access_token]
      # Set the token on the user session
      session[:user_jwt] = {value: token, httponly: true}

      @json = doorkeeper_access_token(token).get("api/v1/members/profile").parsed
      
      @user = User.from_oauth(@json.dig("data", "attributes"))
      @user.update_credentials(token)

      sign_in_and_redirect @user, event: :authentication
    rescue StandardError => e
      flash[:alert] = e.message
      failure
    end
  end

  def doorkeeper2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      @user.update_doorkeeper_credentials(request.env["omniauth.auth"])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Doorkeeper") if is_navigational_format?
    else
      session["devise.doorkeeper_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
