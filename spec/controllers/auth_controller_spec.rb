require 'rails_helper'

RSpec.describe AuthController do
  describe 'GET #start' do
    it 'works without sign-in' do
      get :start
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'works with sign-in' do
      @user = User.create!(email: 'a@a.com', password: '12345678')
      sign_in @user
      get :start
      expect(response).to redirect_to('http://google.com')
    end
  end
end
