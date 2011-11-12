require 'multi_json'
require 'xmlsimple'
MultiJson.engine = :yajl
module Nedry
  class Base

    @@routes = []

    class << self
      @routes = []
      def get(path, &block); add_route('GET', path, &block) end
      def post(path, &block)
        add_route
      end

      def add_route(request_method, path, &block)
        @@routes << {:request_method => request_method, :path => path, :block => block}
      end

      def match(request_method, path)
        @@routes.each do |route|
          if route[:path] == path && route[:request_method] == request_method
            return route
          end
        end
        nil
      end

      def call(env)
        begin
          self.new.call env
        rescue => e

        end
      end
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

    def call(env)
      begin
        call! env
      rescue
        @response = error 500, 'server_error', 'An unexpected error has occured, please try your request again later.'
        render
        rack_response
      end
    end

    def call!(env)
      @env = env
      @headers = {}

      id_match = path.match(/\/:(\w+)/)
      id = id_match.nil? ? nil : id_match.captures.first

      format_match = path.match(/.(\w+)$/)
      @format = format_match.nil? ? 'json' : format_match.captures.first

      route = self.class.match request_method, path

      if route.nil?
        @response = error(404, 'not_found', 'The requested method was not found') if route.nil?
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