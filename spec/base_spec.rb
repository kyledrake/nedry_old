require_relative './helper.rb'

describe 'A mock app' do
  include Rack::Test::Methods
  it 'successfully completes a sleep call' do
    mock_app {
      get '/' do
        'ok'
      end
    }
    get '/'
    
    expect_that { last_response.ok? }
    expect_that { last_response.body == {:response => 'ok'}.to_json }
  end
end