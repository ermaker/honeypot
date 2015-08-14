require 'rails_helper'

RSpec.describe User do
  subject { create(described_class) }
  it '#push works' do
    FakeWeb.register_uri(
      :post,
      %r{/shards$},
      content_type: 'application/json',
      body: { id: :id }.to_json
    )

    result = subject.push(
      type: :note,
      title: 'title',
      body: 'body'
    )
    expect(result).to eq('id')
  end
end
