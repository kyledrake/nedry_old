require 'multi_json'
require 'xmlsimple'
MultiJson.engine = :yajl
module Nedry
  
  class Resource
    def initialize(name, &block)
      @name = name.to_sym
      @routes = []
      instance_eval &block
    end

    def collection(action=:index, &block); add_route(:collection, action, block); end
    def member(action=:show, &block);      add_route(:member, action, block);     end

    def to_a
      @routes
    end

    private

    def add_route(type, action, block)
      @routes << {:type => type, :action => action.to_s, :block => block}
    end
  end

  class Base

    @@routes = {}

    class << self
      def resource(name, &block)
        @@routes[name.to_sym] = Resource.new(name, &block).to_a
      end

      def call(env)
        self.new.call env
      end

      def match(request_method, path)
        path_array = path.split /\//
        resource = path_array[1].to_sym
        action = path_array[2]

        if request_method == 'GET'
          if action.nil?
            action = 'index'
            type = :collection
          else
            type = :collection
          end
        end

        @@routes[resource].each do |route|
          return route if route[:type] == type && route[:action] == action
        end
        nil
      end
    end

    def call(env)
      begin
        call! env
      rescue
        fail # We don't want to do this yet (or maybe ever)
        @response = error 500, 'server_error', 'An unexpected error has occured, please try your request again later.'
        render
        rack_response
      end
    end

    def call!(env)
      @env = env
      @headers = {}

      route = self.class.match request_method, path

      

      if route.nil?
        @response = error 404, 'not_found', 'The requested method was not found'
      else
        @response = route[:block].call @env, params
      end

      if (@response.is_a?(Hash) && !@response[:error]) || !@response.is_a?(Hash)
        @response = {:response => @response}
      end

      render
      rack_response
    end

    def rack_response
      @headers['Content-Type'] = 'text/plain' if params['browser_debug']
      @headers['Content-Length'] = @response.length.to_s
      [200, @headers, [@response]]
    end

    def error(status, type, message)
      {:error => {:type => type, :message => message}}
    end


    def request_method
      @env['REQUEST_METHOD']
    end

    def path
      @env['PATH_INFO']
    end

    def params
      @params ||= Rack::Utils.parse_query @env['QUERY_STRING']
    end

    private

    def render
      if @format == 'xml'
        @response = XmlSimple.xml_out @response,
                                     'NoAttr' => true,
                                     'KeepRoot' => true,
                                     'XmlDeclaration' => '<?xml version="1.0" encoding="UTF-8"?>'
        @headers['Content-Type'] = 'application/xml'
      else
        @response = MultiJson.encode @response
        @headers['Content-Type'] = 'application/json'
      end
    end

  end
end