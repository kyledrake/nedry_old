require './lib/nedry/base.rb'

class App < Nedry::Base
  get '/' do
    test_this
  end
  
  def self.test_this
    'lol'
  end
end

#use Rack::CommonLogger
run App