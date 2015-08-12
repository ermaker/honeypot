# The controller for auth-related actions of Pushbullet
class AuthController < ApplicationController
  before_action :authenticate_user!

  def start
    redirect_to 'http://google.com'
  end
end
