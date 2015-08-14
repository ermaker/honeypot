require 'rails_helper'

RSpec.describe SettingController do
  describe 'GET #edit_sw_cert' do
    it 'works' do
      create(:log_sw_cert)
      get :edit_sw_cert
      expect(response).to be_success
      expect(response).to render_template(:edit_sw_cert)
      expect(assigns(:candidates).size).to eq(8)
      skip('TODO')
    end
  end
end
