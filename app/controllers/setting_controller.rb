# The setting controller
class SettingController < ApplicationController
  def edit_sw_cert
    @candidates = Log.recent(type: :sw_cert).status
  end
end
