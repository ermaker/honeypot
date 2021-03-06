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
      sign_in create(:user)
      get :start
      expect(response).to redirect_to(subject.pushbullet_authorize_uri)
    end
  end

  describe 'GET #complete' do
    it 'works without sign-in' do
      get :complete
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'works with sign-in' do
      sign_in create(:user)
      FakeWeb.register_uri(
        :post,
        'https://api.pushbullet.com/oauth2/token',
        content_type: 'application/json',
        body: { token_type: :Bearer, access_token: :access_token }.to_json
      )

      get :complete, code: :code, state: nil
      expect(subject.current_user.token_type).to eq('Bearer')
      expect(subject.current_user.access_token).to eq('access_token')
      expect(response).to be_success
    end
  end
end
