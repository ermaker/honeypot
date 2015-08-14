require 'rails_helper'

RSpec.describe SettingController do
  describe 'GET #edit_sw_cert' do
    xit 'works' do
      get :edit_sw_cert
      expect(response).to be_success
      expect(response).to render_template(:edit_sw_cert)
      expect(assigns(:candidates)).to eq('')
    end
  end
end
