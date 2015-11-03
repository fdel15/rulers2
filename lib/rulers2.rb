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
      controller = klass.new(env)
      begin
        text = controller.send(act)
      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        controller.render(act)
      end
      rescue => e
        puts e
        text = e.to_s.split("for").first + "for #{controller.class}"
        [500, {'Content-Type' => 'text/html'}, [text]]
      end
    end
  end
end
