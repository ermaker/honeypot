require 'rails_helper'

RSpec.describe SettingController do
  describe 'GET #edit_sw_cert' do
    it 'works' do
      get :edit_sw_cert
      expect(response).to be_success
    end
  end
end
