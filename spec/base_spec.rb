require_relative './helper.rb'

describe 'A mock app' do
  include Rack::Test::Methods
  it 'does basic return' do
    mock_app {
      resource :systems do
        collection do
          [{:name => 'Main Security Grid'}]
        end
      end
    }
    get '/systems'

    expect_that { last_response.ok? }
    expect_that { last_response.body == {:response => [{:name => 'Main Security Grid'}]}.to_json }
  end

end