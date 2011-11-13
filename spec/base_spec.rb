require_relative './helper.rb'

describe 'A mock app' do
  include Rack::Test::Methods
  it 'does collection index return' do
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
  
  it 'does collection fences return' do
    fences = [{:name => 'Raptor fence', :status => 'offline'}]
    mock_app {
      resource :systems do
        collection :fences do
          fences
        end
      end
    }
    get '/systems/fences'

    expect_that { last_response.ok? }
    expect_that { last_response.body == {:response => fences}.to_json }
  end
end