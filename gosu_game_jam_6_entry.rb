if RUBY_ENGINE == "mruby"
  def require_relative(path)
    require "./#{path}"
  end

  def warn(message)
    puts message
  end

  module Gosu
    GP_DPAD_LEFT = 269
    GP_DPAD_RIGHT = 270
    GP_DPAD_UP = 271
    GP_DPAD_DOWN = 272
  end
else
  begin
    require_relative "../cyberarm_engine/lib/cyberarm_engine"
  rescue LoadError
    require "cyberarm_engine"
  end
end

class GGJ6E
  ROOT_PATH = File.expand_path("..", __FILE__)
  MEDIA_PATH = format("%s/media", ROOT_PATH)
end

require_relative "lib/theme"
require_relative "lib/window"
require_relative "lib/states/main_menu"
require_relative "lib/states/game"

GGJ6E::Window.new(width: 1280, height: 720).show
