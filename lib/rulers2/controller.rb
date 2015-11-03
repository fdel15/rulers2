  require "erubis"
  require "rulers2/file_model"
  require "rack/request"

  module Rulers2
    class Controller
      include Rulers2::Model
      def initialize(env)
        @env = env
      end

      def env
        @env
      end

      def request
        @request ||= Rack::Request.new(@env)
      end

      def params
        request.params
      end

      def render(view_name, locals = {})
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
