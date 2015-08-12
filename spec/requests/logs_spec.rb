require 'rails_helper'

RSpec.describe 'Logs', type: :request do
  describe 'GET /logs' do
    xit 'works! (now write some real specs)' do
      get logs_path
      expect(response).to have_http_status(200)
    end
  end
end
