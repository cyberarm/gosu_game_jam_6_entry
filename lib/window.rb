class GGJ6E
  class Window < CyberarmEngine::Window
    def setup
      self.show_cursor = true

      push_state(CyberarmEngine::IntroState, forward: GGJ6E::States::MainMenu)
    end
  end
end
