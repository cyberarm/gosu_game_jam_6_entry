class GGJ6E
  class Window < CyberarmEngine::Window
    def setup
      self.show_stats_plotter = false
      self.show_cursor = true
      self.caption = "Gosu Game Jam 6 Entry | \"Run and Gun\" | by cyberarm"

      push_state(GGJ6E::States::MainMenu) if RUBY_ENGINE == "mruby"
      push_state(CyberarmEngine::IntroState, forward: GGJ6E::States::MainMenu) unless RUBY_ENGINE == "mruby"
    end
  end
end
