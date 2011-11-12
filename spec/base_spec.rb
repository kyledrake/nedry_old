require_relative './helper.rb'

describe 'A mock app' do
  include Rack::Test::Methods
  it 'does basic return' do
    mock_app {
      get '/' do
        'ok'
      end
    }
    get '/'
    
    expect_that { last_response.ok? }
    expect_that { last_response.body == {:response => 'ok'}.to_json }
  end
  
  it 'returns get with json' do
    mock_app {
      get '/systems.json' do
        [{:name => 'Main Security Grid'}]
      end
    }
    get '/systems.json'
    
    expect_that { last_response.ok? }
    expect_that { last_response.body == {:response => [{:name => 'Main Security Grid'}]}.to_json }
  end
  
  it 'returns get with xml' do
    mock_app {
      get '/systems.xml' do
        [{:name => 'Main Security Grid'}]
      end
    }
    get '/systems.xml'
    
    expect_that { last_response.ok? }
    expect_that { last_response.body == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<response>\n  <name>Main Security Grid</name>\n</response>\n" }
  end
  
  it 'returns 404 with json' do
    mock_app {}
    get '/access_main_security_grid.json'
    
    expect_that { last_response.ok? }
    expect_that { last_response.body == {:error => {:type => 'not_found', :message => 'The requested method was not found'}}.to_json }
  end
  
  it 'returns 500 on generic error' do
    mock_app {
      get '/error' do
        raise 'HA HA HA'
      end
    }
    get '/error'
    
    expect_that { last_response.ok? }
    expect_that { last_response.body == 
                  {:error => {:type => 'server_error', 
                              :message => 'An unexpected error has occured, please try your request again later.'}}.to_json }
  end
end