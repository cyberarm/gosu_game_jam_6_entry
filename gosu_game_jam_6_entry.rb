begin
  require_relative "../cyberarm_engine/lib/cyberarm_engine"
rescue LoadError
  require "cyberarm_engine"
end

class GGJ6E
  ROOT_PATH = File.expand_path(".", __dir__)
  MEDIA_PATH = format("%s/media", ROOT_PATH)
end

require_relative "lib/theme"
require_relative "lib/window"
require_relative "lib/states/main_menu"
require_relative "lib/states/game"

GGJ6E::Window.new(width: 1280, height: 720).show
