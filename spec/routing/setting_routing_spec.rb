require 'rails_helper'

RSpec.describe 'routing to setting' do
  it 'routes /setting/sw_cert to setting#edit_sw_cert' do
    expect(get: '/setting/sw_cert').to route_to(
      controller: 'setting',
      action: 'edit_sw_cert'
    )
  end

  it 'routes /setting/sw_cert to setting#update_sw_cert' do
    expect(put: '/setting/sw_cert').to route_to(
      controller: 'setting',
      action: 'update_sw_cert'
    )
  end
end
