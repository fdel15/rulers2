  require "erubis"
  require "rulers2/file_model"
  require "rack/request"

  module Rulers2
    class Controller
      include Rulers2::Model

      def initialize(env)
        @env = env
        @routing_params = {}
      end

      def env
        @env
      end

      def dispatch(action, routing_params = {})
        @routing_params = routing_params
        text = self.send(action)
        if get_response
          st, hd, rs = get_response.to_a
          [st, hd, [rs].flatten]
        else
          [200, { 'Content-Type' => 'text/html' }, [text].flatten]
        end
      end

      def self.action(act, rp = {})
        proc { |e| self.new(e).dispatch(act, rp) }
      end

      def response(text, status = 200, headers = {})
        raise "Already responded!" if @response
        a = [text].flatten
        @response = Rack::Response.new(a, status, headers)
      end

      def get_response
        @response
      end

      def render(*args)
        get_view(*args)
      end

      def request
        @request ||= Rack::Request.new(@env)
      end

      def params
        request.params.merge @routing_params
      end

      def get_view(view_name, locals = {})
        filename = File.join "app", "views", controller_name, "#{view_name}.html.erb"
        template = File.read filename
        eruby = Erubis::Eruby.new(template)
        eruby.result locals.merge(my_instance_variables)
      end

      def my_instance_variables(vars = {})
        self.instance_variables.each{|v| vars[v] = self.instance_variable_get(v)}
        vars
      end

      def controller_name
        klass = self.class
        klass = klass.to_s.gsub /Controller$/, ""
        Rulers2.to_underscore klass
      end
    end
  end
