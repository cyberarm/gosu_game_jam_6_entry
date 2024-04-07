class GGJ6E
  class States
    class MainMenu < CyberarmEngine::GuiState
      def setup
        theme(GGJ6E::THEME)

        stack(width: 1.0, height: 1.0, padding: 16) do
          background 0xff_224422..0xff_002200

          banner "Gosu Game Jam 6 Entry", width: 1.0, text_align: :center

          flow(width: 1.0, fill: true) do
            flow(width: 0.25, max_width: 350, height: 1.0) do
              button "PLAY", width: 1.0 do
                pop_state
                push_state(GGJ6E::States::Game)
              end

              button "EXIT", width: 1.0 do
                window.close
              end
            end

            stack(height: 1.0, fill: true, margin_left: 32) do
              title "How to play"
              tagline "Don't run into cactus, avoid angry cubes, and snails."
            end
          end

          caption "A game by cyberarm", width: 1.0, text_align: :center
          caption "For the Gosu Game Jam 6: <b>Run and Gun</b>", width: 1.0, text_align: :center
        end
      end

      def button_down(id)
        super

        case id
        when Gosu::KB_ENTER, Gosu::KB_RETURN, Gosu::KB_SPACE
          pop_state
          push_state(GGJ6E::States::Game)
        when Gosu::GP_BUTTON_0..Gosu::GP_BUTTON_15
          pop_state
          push_state(GGJ6E::States::Game)
        end
      end
    end
  end
end
