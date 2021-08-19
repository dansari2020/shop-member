class ApiController < ApplicationController
  respond_to :json

  def explore
    begin
      resp = doorkeeper_access_token.get("api/v1/#{params[:api]}")
      if resp.status >= 200
        respond_with resp.parsed
      else
        sign_out if resp.status >= 401
        render json: {error: e.message}, status: resp.status
      end
    rescue StandardError => e
      sign_out
      render json: {error: e.message}, status: :unauthorized
    end
  end
end
