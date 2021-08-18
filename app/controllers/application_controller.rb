class ApplicationController < ActionController::Base

  def doorkeeper_oauth_client(site = ENV["DOORKEEPER_APP_URL"])
    OAuth2::Client.new(
      ENV["DOORKEEPER_APP_ID"],
      ENV["DOORKEEPER_APP_SECRET"],
      authorize_url: '/oauth/authorize',
      site: site,
      token_url: '/oauth/token',
      redirect_uri: ENV["APP_CALLBACK_URL"])
  end

  def doorkeeper_access_token(token = nil)
    token ||= current_user.doorkeeper_access_token
    OAuth2::AccessToken.new(
      doorkeeper_oauth_client, token
    )
  end
end
