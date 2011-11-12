ENV['RACK_ENV'] = 'test'
require_relative '../lib/nedry.rb'
require 'rack/test'
require 'minitest/autorun'
require 'wrong/adapters/minitest'
require 'json'
Wrong.config.alias_assert :expect_that

def app; @app end
  
def mock_app(&block)
  @app = Nedry::Base
  @app.class_eval &block
  @app
end