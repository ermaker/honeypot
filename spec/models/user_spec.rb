require 'rails_helper'

RSpec.describe User do
  subject do
    User.create!(
      email: 'a@a.com',
      password: '12345678',
      token_type: :Bearer,
      access_token: 'o.JpVq5V1AWSYRynNkAx6QluAxHpV5cuah'
    )
  end

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
