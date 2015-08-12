require 'rails_helper'

RSpec.describe 'logs/new', type: :view do
  before(:each) do
    assign(:log, Log.new(
                   type: ''
    ))
  end

  it 'renders new log form' do
    render

    assert_select 'form[action=?][method=?]', logs_path, 'post' do
      assert_select 'input#log_type[name=?]', 'log[type]'
    end
  end
end
