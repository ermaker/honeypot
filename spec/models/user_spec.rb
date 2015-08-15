require 'rails_helper'

RSpec.describe User do
  it '#push works' do
    FakeWeb.register_uri(
      :post,
      %r{/shards$},
      content_type: 'application/json',
      body: { id: :id }.to_json
    )

    result = create(described_class).push(
      type: :note,
      title: 'title',
      body: 'body'
    )
    expect(result).to eq('id')
  end

  it '#sw_cert_setting works' do
    expect(create(described_class).sw_cert_setting.size).to eq(8)
  end
end
