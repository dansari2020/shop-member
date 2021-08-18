class Users::OmniauthCallbacksController < ApplicationController
  require 'oauth2'
  before_action :oauth_client
  CLIENT_ID = ENV["DOORKEEPER_APP_ID"]
  CLIENT_SECRET = ENV["DOORKEEPER_APP_SECRET"]
  APP_URL = ENV["DOORKEEPER_FRONTEND_APP_URL"] || ENV["DOORKEEPER_APP_URL"]
  CALLBACK_URL = ENV["APP_CALLBACK_URL"]
  def oauth_client
    @oauth_client ||= OAuth2::Client.new(CLIENT_ID,
                                       CLIENT_SECRET,
                                       authorize_url: '/oauth/authorize',
                                       site: APP_URL,
                                       token_url: '/oauth/token',
                                       redirect_uri: CALLBACK_URL)
  end

  def user_authorize
    redirect_to oauth_client.auth_code.authorize_url(scope: "read")
  end

    # The OAuth callback
  def doorkeeper
    # Make a call to exchange the authorization_code for an access_token
    response = @oauth_client.auth_code.get_token(params[:code])

    # Extract the access token from the response
    token = response.to_hash[:access_token]
    # Set the token on the user session
    session[:user_jwt] = {value: token, httponly: true}

    @json = doorkeeper_access_token.get("api/v1/members/profile", headers: {'Authorization' => token }).parsed

    render json: @json
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
