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

  describe 'PUT #update_sw_cert' do
    it 'works' do
      # rubocop:disable Metrics/LineLength
      setting = [
        ['2015년 9월', '12', 'Professional 검정   13:30 ~ 17:30 ( C/C++/JAVA )', '인재개발원(서천)'],
        ['2015년 9월', '19', 'Advanced 검정   13:30 ~ 16:30 ( C/C++/JAVA )', '스마트시티(구미)']
      ]
      # rubocop:enable Metrics/LineLength
      sign_in create(:user)
      create(:log_sw_cert)
      put :update_sw_cert,
          'user' => { 'sw_cert_setting' => setting.map(&:to_json) }
      expect(response).to redirect_to(:setting_sw_cert)
      expect(subject.current_user.sw_cert_setting).to eq(setting)
    end
  end
end
