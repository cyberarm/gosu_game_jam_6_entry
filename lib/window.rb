class GGJ6E
  class Window < CyberarmEngine::Window
    def setup
      self.show_cursor = true
      self.caption = "Gosu Game Jam 6 Entry | \"Run and Gun\" | by cyberarm"

      push_state(CyberarmEngine::IntroState, forward: GGJ6E::States::MainMenu)
    end
  end
end
