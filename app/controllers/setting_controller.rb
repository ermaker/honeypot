# The setting controller
class SettingController < ApplicationController
  def edit_sw_cert
    @sw_cert_setting = current_user.sw_cert_setting
    @candidates = Log.sw_cert_candidates
    @sw_cert_setting_checkbox = @candidates.map do |items|
      [items, @sw_cert_setting.include?(items)]
    end
  end

  def update_sw_cert
    current_user.update_attribute(
      :sw_cert_setting,
      params[:user][:sw_cert_setting].map { |item| JSON.parse(item) }
    )
    redirect_to(:setting_sw_cert)
  end
end
