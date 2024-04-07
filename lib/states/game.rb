class GGJ6E
  class States
    class Game < CyberarmEngine::GuiState
      GameObject = Struct.new(:image, :position, :velocity, :scale, :health, :box)
      TILE_SIZE = 70
      PLAYER_HEIGHT = 97
      GRAVITY = 9.8

      def setup
        theme(THEME)

        stack(width: 1.0, height: 1.0, z: -1) do
          background 0xff_22aeff..0xff_1ea7e1

          @distance_label = title "DISTANCE: 0 meters", margin: 32
        end

        @tiles = {
          grass: get_image(format("%s/Base pack/Tiles/grassMid.png", MEDIA_PATH)),
          dirt: get_image(format("%s/Base pack/Tiles/grassCenter.png", MEDIA_PATH)),
          water_a: get_image(format("%s/Base pack/Tiles/liquidWaterTop.png", MEDIA_PATH)),
          water_b: get_image(format("%s/Base pack/Tiles/liquidWaterTop_mid.png", MEDIA_PATH))
        }

        @clouds = {
          cloud_a: get_image(format("%s/Base pack/Items/cloud1.png", MEDIA_PATH)),
          cloud_b: get_image(format("%s/Base pack/Items/cloud2.png", MEDIA_PATH)),
          cloud_c: get_image(format("%s/Base pack/Items/cloud3.png", MEDIA_PATH))
        }

        @sign_right = get_image(format("%s/Base pack/Tiles/signRight.png", MEDIA_PATH))

        @cactus = get_image(format("%s/Base pack/Items/cactus.png", MEDIA_PATH))
        @blocker = get_image(format("%s/Base pack/Enemies/blockerMad.png", MEDIA_PATH))
        @cactus_box = CyberarmEngine::BoundingBox.new(27, 16, 43, 70)
        @blocker_box = CyberarmEngine::BoundingBox.new(4, 4, 48, 48)

        @player = get_image(format("%s/Base pack/Player/p1_stand.png", MEDIA_PATH))
        @gun = get_image(format("%s/Request pack/Tiles/raygunBig.png", MEDIA_PATH))
        @bullet = get_image(format("%s/Request pack/Tiles/laserPurple.png", MEDIA_PATH))
        @bullet_box = CyberarmEngine::BoundingBox.new(22, 31, 50, 37)

        @offset_x = 0
        @velocity_y = 0.0
        @speed = 210
        @look_angle = 0.0
        @bullet_speed = @speed
        @bullet_damage = 100.0 / 3.0
        @last_bullet_spawned_at = 0

        @x = 128
        @base_y = window.height - PLAYER_HEIGHT * 3.1
        @y = window.height - PLAYER_HEIGHT * 3.1

        @bullets = []
        @sparks = []
        @enemies = []

        @random_table = [
          0.7131145686298177, 0.9964349573410236, 0.6922118704794343, 0.46555536957425825, 0.9923425937976738,
          0.3161155350274808, 0.5783077025427338, 0.8616432844700936, 0.5364830229842563, 0.04722134258017219,
          0.4587870067399148, 0.5375979019429578, 0.8400594451045087, 0.96100751398506, 0.4189746833420598,
          0.219437391641087, 0.7763913966912207, 0.7737506355908558, 0.2306725943849276, 0.28322939890036736,
          0.4485128310850881, 0.605311055332505, 0.2818672568574093, 0.026681438812278135, 0.843149197488104,
          0.639216946986057,  0.13872880600797377,  0.33241677070108155,  0.38100371552458456,  0.01743551799328813,
          0.9263094017039057, 0.1316861238725412, 0.11717967661133855, 0.08185704912507696, 0.5055909367728747,
          0.7870394101135813, 0.924511447823148, 0.4278068285970438, 0.5843047048882365, 0.7822156430137525,
          0.9964267507644552, 0.5504131696698988, 0.2938365359862912, 0.8089123320170051, 0.8638461421690667,
          0.6784288920903606, 0.12521656736413544, 0.9924995248428709, 0.4457032711557727, 0.24972077124886272,
          0.5242443485125916, 0.10569038060173885, 0.9063541299621735, 0.33765418523673396, 0.8844669152753899,
          0.9158630752711309, 0.29672612829134737, 0.5521083272305412, 0.07814311615536695, 0.9890473948703968,
          0.813487967131779, 0.5929356313760986, 0.8372644655896978, 0.7407154757784409, 0.12374113461545044,
          0.29965665534329555, 0.20721529815020645, 0.5066578557969676, 0.6818967767391301, 0.27238084804092366,
          0.673013696183647, 0.5716473559223803, 0.20832352507285234, 0.8674888123541319, 0.006487944932028089,
          0.21730133437348365, 0.14652746002945305, 0.08537219695553955, 0.26776574796356745, 0.3596768359533702,
          0.24257249626440003, 0.17765554876910183, 0.6287825619813527, 0.04002704260073653, 0.2754764089437918,
          0.5414581911647898, 0.7472585128522719, 0.6943255467499323, 0.9798159217294026, 0.03999540619007358,
          0.6173096391026139, 0.07912170797857498, 0.1526144105447813, 0.7548009793700455, 0.2628835436885193,
          0.7380186328909327, 0.6073208125674296, 0.7997052957815394, 0.17637196913065134, 0.9702506296347502,
          0.1950730031706076, 0.9139770804606702, 0.8941821087910762, 0.6474484347142849, 0.6119089908516752,
          0.8421289193686411, 0.11837078481301755, 0.826872779377902, 0.6586354263416753, 0.7196505205191953,
          0.5617192755770153, 0.5475194181218626, 0.3226778009444702, 0.003151284098611651, 0.7231477888938751,
          0.6753926288785485, 0.6098743909296663, 0.08819050735313194, 0.9222244353862052, 0.46442173697916656,
          0.09227110645455228, 0.8369962206723491, 0.9121668239352275, 0.10706302240638488, 0.34444687389816464,
          0.31378151030985046, 0.9491969391225301, 0.2845873401632749, 0.6014664743733185, 0.6408843736354016,
          0.030857895694314852, 0.9007430063037682, 0.6347369633354131, 0.5144903869170168, 0.27157075030159517,
          0.8228383175344309, 0.32258238928649385, 0.11665372554953946, 0.7750005383304949, 0.8383455895313761,
          0.31466902769854566, 0.09928384644808241, 0.45754554985479656, 0.815458507835879, 0.8051332161895322,
          0.4026048374457857, 0.6337539819582029, 0.6726806717705383, 0.44986107004139775, 0.10532560374948086,
          0.05855501157916121, 0.11843630678791162, 0.9585984127349396, 0.7712592902948084, 0.9209522530234204,
          0.7827546679935596, 0.4308760847946159, 0.648020833008673, 0.5411736665069697, 0.5464278860619358,
          0.01283060004298231, 0.009534010376769486, 0.8514187631832324, 0.9043320215208874, 0.6100055712987411,
          0.13104878225980443, 0.5077337452182071, 0.21766392815187907, 0.74315847460627, 0.14808591136581273,
          0.09708896221254659, 0.19040318169500237, 0.1620809475088607, 0.02824637054358714, 0.3197673595899785,
          0.8054953905099664, 0.38134873741056396, 0.5075725775160375, 0.9326915886888018, 0.06729717796007073,
          0.13973198003785214, 0.168386564149694, 0.08169936507847375, 0.10728799162380687, 0.4913310041315512,
          0.16337475200485674, 0.10560165070458194, 0.7222260245426968, 0.182579203477515, 0.035159995645402065,
          0.9123338876157806, 0.3340998024144123, 0.699154920170633, 0.42901645796494603, 0.47522146070046545,
          0.7460438855873162, 0.697241114638643, 0.18274493423783, 0.3554641999246638, 0.22510940901350007,
          0.11392108650152777, 0.9763524924907755, 0.8960812104681039, 0.49772831419378694, 0.20602921799995422,
          0.5058616575848767, 0.10740966735613522, 0.8629974737714885, 0.5255020726456309, 0.30249335567729896,
          0.45427849735167625, 0.775734239221397, 0.4405337464439112, 0.004630727219444686, 0.3779458506816049,
          0.9977594052686334, 0.5778276213822154, 0.8474054648842965, 0.7705956285759122, 0.7255054855760473,
          0.005497674332023417, 0.16492954023325945, 0.11114772756921076, 0.6793786931938357, 0.21048898741835464,
          0.6060290893189245, 0.8278437051099984, 0.10147227776831669, 0.7615428887552369, 0.5587408937276704,
          0.5010007154881323, 0.013951703758627976, 0.9201250389374934, 0.70969506637945, 0.7308420267536204,
          0.8010772993963947, 0.1884257806602636, 0.8705526257026356, 0.9410438034312352, 0.2630786714444191,
          0.509942825929834, 0.3257760681266554, 0.23892126678159076, 0.14321284572142268, 0.20716180103237425,
          0.8113427639042381, 0.8272734751716428, 0.3243519426098588, 0.7119995857751938, 0.3776440368881946,
          0.20804270844298012, 0.22537352752908757, 0.465578855197352, 0.8538615061195138, 0.5713405698844113,
          0.9324597021602132
        ].freeze
        @random_table_index = 72

        1000.times do |i|
          r = Math.sqrt(prand)

          next unless r > 0.8

          is_cactus = r > 0.9

          @enemies << GameObject.new(
            is_cactus ? @cactus : @blocker,
            CyberarmEngine::Vector.new(TILE_SIZE * i, window.height - TILE_SIZE * (is_cactus ? 4 : 3.7)),
            CyberarmEngine::Vector.new,
            CyberarmEngine::Vector.new(1, 1, 0),
            100.0,
            is_cactus ? @cactus_box : @blocker_box
          )
        end
      end

      def draw
        super

        @player.draw(@x, @y, 0)
        @gun.draw_rot(@x + TILE_SIZE / 2 + 12, @y + (TILE_SIZE * 0.75), 0, @look_angle, 0.0, 0.5)
        @sign_right.draw(256 - @offset_x, window.height - TILE_SIZE * 4, 0)


        # How many tiles to draw on screen, plus overdraw to hide pop-in
        tile_count = window.width / TILE_SIZE + 2

        @enemies.each do |e|
          break if e.position.x > window.width + TILE_SIZE

          e.image.draw(e.position.x, e.position.y, 0)
          box = e.box.normalize_with_offset(e)

          debug_draw_box(box)
        end

        @bullets.each do |e|
          e.image.draw(e.position.x, e.position.y, 0)
          box = e.box.normalize_with_offset(e)

          debug_draw_box(box, Gosu::Color::YELLOW)
        end

        x = -@offset_x.round % TILE_SIZE - TILE_SIZE
        y = window.height - TILE_SIZE * 3
        tile_count.times do |i|
          @tiles[:grass].draw(x, y, 0)
          x += TILE_SIZE
        end

        x = -@offset_x.round % TILE_SIZE - TILE_SIZE
        y = window.height - TILE_SIZE * 2
        tile_count.times do |i|
          @tiles[:dirt].draw(x, y, 0)
          x += TILE_SIZE
        end

        x = -@offset_x.round % TILE_SIZE - TILE_SIZE
        y = window.height - TILE_SIZE
        tile_count.times do |i|
          @tiles[:dirt].draw(x, y, 0)
          @tiles[:water_a].draw(x, y + 4, 0) if i.even?
          @tiles[:water_b].draw(x, y + 4, 0) if i.odd?
          x += TILE_SIZE
        end
      end

      def update
        super

        # @offset_x += @speed * window.dt if Gosu.button_down?(Gosu::GP_RIGHT) || Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::KB_D)
        # @offset_x -= @speed * window.dt if Gosu.button_down?(Gosu::GP_LEFT) || Gosu.button_down?(Gosu::KB_LEFT) || Gosu.button_down?(Gosu::KB_A)

        delta_x = @speed * window.dt
        @offset_x += delta_x

        @velocity_y -= GRAVITY * 200 * window.dt

        @y -= @velocity_y * window.dt

        @velocity_y = 0.0 if @y >= @base_y
        @y = @base_y if @y > @base_y

        @velocity_y += 768 if @y == @base_y && (Gosu.button_down?(Gosu::GP_DPAD_UP) || Gosu.axis(Gosu::GP_LEFT_STICK_Y_AXIS) > 0.25 || Gosu.button_down?(Gosu::KB_UP) || Gosu.button_down?(Gosu::KB_W))

        @distance_label.value = format("DISTANCE: %d meters", @offset_x / TILE_SIZE.to_f)

        @look_angle = Gosu.angle(@x + TILE_SIZE / 2 + 12, @y + (TILE_SIZE * 0.75), window.mouse_x, window.mouse_y) - 90.0

        spawn_bullet # if (Gosu.axis(Gosu::GP_RIGHT_TRIGGER_AXIS) > 0.25 || Gosu.button_down?(Gosu::GP_BUTTON_0) || Gosu.button_down?(Gosu::KB_SPACE) || Gosu.button_down?(Gosu::KB_X) || Gosu.button_down?(Gosu::KB_C))

        @enemies.each do |e|
          e.position.x -= delta_x
          @enemies.delete(e) if e.position.x <= -TILE_SIZE
        end

        @bullets.each do |b|
          b.position.x += delta_x + @bullet_speed * window.dt
        end

        # bullet collision
        ## select valid enemies
        enemies = @enemies.select do |e|
          e.position.x <= window.width
        end

        ## find and handle any collisions
        @bullets.each do |b|
          # normalize box so it is projected to "world space"
          bbox = b.box.normalize_with_offset(b)

          enemies.each do |e|
            # normalize box so it is projected to "world space"
            ebox = e.box.normalize_with_offset(e)

            if bbox.intersect?(ebox)
              @bullets.delete(b)

              e.health -= @bullet_damage
              @enemies.delete(e) if e.health <= 0.0
            end
          end
        end
      end

      def prand
        @random_table_index += 1
        @random_table_index %= @random_table.size

        @random_table[@random_table_index]
      end

      def spawn_bullet
        return unless Gosu.milliseconds - @last_bullet_spawned_at >= 250.0
        @last_bullet_spawned_at = Gosu.milliseconds

        @bullets << GameObject.new(
          @bullet,
          CyberarmEngine::Vector.new(@x + TILE_SIZE / 2 + 12, @y + (TILE_SIZE * 0.75) - @bullet.height / 2),
          CyberarmEngine::Vector.new(1.0, 0.0),
          CyberarmEngine::Vector.new(1, 1),
          100.0,
          @bullet_box
        )
      end

      def debug_draw_box(box, color = Gosu::Color::RED)
        # Top
        Gosu.draw_line(
          box.min.x, box.min.y, color,
          box.max.x, box.min.y, color, 1
        )
        # Right
        Gosu.draw_line(
          box.max.x, box.min.y, color,
          box.max.x, box.max.y, color, 1
        )
        # Bottom
        Gosu.draw_line(
          box.max.x, box.max.y, color,
          box.min.x, box.max.y, color, 1
        )
        # Left
        Gosu.draw_line(
          box.min.x, box.max.y, color,
          box.min.x, box.min.y, color, 1
        )
      end
    end
  end
end
