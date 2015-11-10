require "rulers2/array"
require "rulers2/controller"
require "rulers2/dependencies"
require "rulers2/file_model"
require "rulers2/routing"
require "rulers2/util"
require "rulers2/version"

module Rulers2
  class Application
    def call(env)
      if env['PATH_INFO'] == '/favicon.ico'
        return [404, {'Content-Type' => 'text/html'}, []]
      end

      klass, act = get_controller_and_action(env)
      rack_app = klass.action(act)
      rack_app.call(env)
    end
  end
end
