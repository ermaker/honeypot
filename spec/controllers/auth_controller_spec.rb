require 'rails_helper'

RSpec.describe AuthController do
  it '#pushbullet_authorize_uri works' do
    uri = subject.pushbullet_authorize_uri
    expect(uri).to be_start_with('https://www.pushbullet.com/authorize')
  end

  describe 'GET #start' do
    it 'works without sign-in' do
      get :start
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'works with sign-in' do
      @user = User.create!(email: 'a@a.com', password: '12345678')
      sign_in @user
      get :start
      expect(response).to redirect_to(subject.pushbullet_authorize_uri)
    end
  end
end
