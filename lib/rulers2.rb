require "rulers2/array"
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
      controller = klass.new(env)
      begin
        text = controller.send(act)
      [200, {'Content-Type' => 'text/html'}, [text]]
      rescue => e
        puts e
        text = e.to_s.split("for").first + "for #{controller.class}"
        [500, {'Content-Type' => 'text/html'}, [text]]
      end
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
