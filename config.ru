require './lib/nedry/base.rb'

class App < Nedry::Base
  resource :widgets do
    collection :name do
      [{:raptors => 'whoa'}]
    end
  end
  
  def self.test_this
    'lol'
  end
end

#use Rack::CommonLogger
run App