require 'rails_helper'

RSpec.describe SettingController do
  describe 'GET #edit_sw_cert' do
    it 'works' do
      sign_in create(:user)
      create(:log_sw_cert)
      get :edit_sw_cert
      expect(response).to be_success
      expect(response).to render_template(:edit_sw_cert)
      expect(assigns(:sw_cert_setting).size).to eq(5)
      expect(assigns(:candidates).size).to eq(8)
      expect(assigns(:sw_cert_setting_checkbox).size).to eq(8)
    end
  end
end
