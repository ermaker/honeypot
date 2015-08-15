# The setting controller
class SettingController < ApplicationController
  def edit_sw_cert
    @sw_cert_setting = current_user.sw_cert_setting
    @candidates = Log.sw_cert_candidates
    @sw_cert_setting_checkbox = @candidates.map do |items|
      [items, @sw_cert_setting.include?(items)]
    end
  end
end
