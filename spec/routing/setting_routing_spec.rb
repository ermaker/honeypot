require 'rails_helper'

RSpec.describe 'routing to setting' do
  it 'routes /setting/sw_cert to setting#edit_sw_cert' do
    expect(get: '/setting/sw_cert').to route_to(
      controller: 'setting',
      action: 'edit_sw_cert'
    )
  end
end
