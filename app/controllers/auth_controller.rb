# The controller for auth-related actions of Pushbullet
class AuthController < ApplicationController
  before_action :authenticate_user!

  def pushbullet_authorize_uri
    URI('https://www.pushbullet.com/authorize').tap do |uri|
      uri.query = {
        client_id: ENV['PUSHBULLET_CLIENT_ID'],
        redirect_uri: request.base_url + auth_complete_path,
        response_type: :code
      }.to_query
    end.to_s
  end

  def start
    redirect_to(pushbullet_authorize_uri)
  end

  def complete
    @code = params[:code]
  end
end
