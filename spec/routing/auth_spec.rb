require 'rails_helper'

RSpec.describe 'routing to auth' do
  it 'routes /auth/start to auth#start' do
    expect(get: '/auth/start').to route_to(
      controller: 'auth',
      action: 'start'
    )
  end

  it 'routes /auth/complete to auth#complete' do
    expect(get: '/auth/complete').to route_to(
      controller: 'auth',
      action: 'complete'
    )
  end
end
