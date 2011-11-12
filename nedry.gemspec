Gem::Specification.new do |s|
  s.name = 'nedry'
  s.version = '0.0.1'
  s.authors = ['Kyle Drake']
  s.email = ['kyledrake@gmail.com']
  s.homepage = "https://github.com/kyledrake/#{s.name}"
  s.summary = 'New API Idea'
  s.description = 'New API Idea!'

  s.files = Dir['{lib,spec}/**/*'] + Dir['[A-Z]*']
  s.require_path = 'lib'

  s.rubyforge_project = s.name
  s.required_rubygems_version =         '>= 1.3.4'
  s.add_dependency 'rack',              '>= 1.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rack-test', '= 0.5.7'
  s.add_development_dependency 'wrong',     '= 0.5.0'
  s.add_development_dependency 'minitest'
end
