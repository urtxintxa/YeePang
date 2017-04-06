class Player

  attr_reader :shape
  attr_writer :dead

  def initialize(window)
    @window = window
    @x = 321 ; @y = 278 ; @imgId = 0; @width = @height = 56
    @left = Gosu::Image.load_tiles("img/player_left.png", @width, @height)
    @right = Gosu::Image.load_tiles("img/player_right.png", @width, @height)
    @deadImg = Gosu::Image.new("img/hurt.png")
    @dead = false
    @direc = :right

    @body = CP::Body::new(10, INFINITY)
    @body.p = CP::Vec2.new(@x-28, @y-28)

    @shape_verts = [
                    CP::Vec2.new(-(@width / 2.0), (@height / 2.0)),
                    CP::Vec2.new((@width / 2.0), (@height / 2.0)),
                    CP::Vec2.new((@width / 2.0), -(@height / 2.0)),
                    CP::Vec2.new(-(@width / 2.0), -(@height / 2.0)),
                   ]

    @shape = CP::Shape::Poly.new(@body, @shape_verts, CP::Vec2.new(0,0))
    @shape.e = 0
    @shape.u = 0
    @shape.collision_type = :player

    @window.space.add_body(@body)
    @window.space.add_shape(@shape)

  end


  def draw
    if !@dead
      if @direc == :right
        @right[@imgId/10].draw(@shape.body.p.x-28, @y, 1)
      else
        @left[@imgId/10].draw(@shape.body.p.x-28, @y, 1)
      end

    else
      @deadImg.draw(@shape.body.p.x - 28, @y, 1)
      @window.space.remove_body(@body)
      @window.space.remove_shape(@shape)
    #  @window.endGame()
    end
  end

  def move(direc)
    @direc = direc
    if 41 <= @x and @x <= SCREEN_WIDTH - 41
      if @direc == :right
        @shape.body.p.x += 2
      else
        @shape.body.p.x -= 2
      end
      @imgId = @imgId + 1
      if @imgId > 39
        @imgId = 0
      end
    end

  end

end
