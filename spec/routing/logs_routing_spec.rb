require 'rails_helper'

RSpec.describe LogsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/logs').not_to be_routable
    end

    it 'routes to #new' do
      expect(get: '/logs/new').not_to be_routable
    end

    it 'routes to #show' do
      expect(get: '/logs/1').not_to be_routable
    end

    it 'routes to #edit' do
      expect(get: '/logs/1/edit').not_to be_routable
    end

    it 'routes to #create' do
      expect(post: '/logs').to route_to('logs#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/logs/1').not_to be_routable
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/logs/1').not_to be_routable
    end

    it 'routes to #destroy' do
      expect(delete: '/logs/1').not_to be_routable
    end
  end
end
