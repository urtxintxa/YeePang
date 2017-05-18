require 'gosu'
require 'chipmunk'

require_relative 'player'
require_relative 'ball'
require_relative 'wall'
require_relative 'harpoon'

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480
INFINITY = 1.0/0

class YeePang < Gosu::Window

  attr_accessor :space

  def initialize
    super 640, 480
    self.caption = "YeePang Jokoa"

    @font = Gosu::Font.new(20)

    @space = CP::Space.new
    @space.gravity = CP::Vec2.new(0, 1)
    @dt = (1.0/60.0)

    @player = Player.new(self)

    @balls = []
    @balls.push(Ball.new(self, 1))
    @balls.push(Ball.new(self, 2))
    @balls.push(Ball.new(self, 3))
    @balls.push(Ball.new(self, 4))

    @ballToRemove = nil

    @wall0 = Wall.new(self, 13, 13, SCREEN_WIDTH - 13, 0)       # up
    @wall1 = Wall.new(self, 13, 347 - 13, SCREEN_WIDTH - 13, 0) # down
    @wall2 = Wall.new(self, 13, 13, 0, 347 - 13)                # left
    @wall3 = Wall.new(self, SCREEN_WIDTH - 13, 13, 0, 347 - 13) # right

    @harpoon = nil

    @back = Gosu::Image.load_tiles("img/back.png", 640, 347)
    @back2 = Gosu::Image.new("img/back2.png")

    @space.add_collision_func(:player, :ball) do
      @player.dead = true
    end
    @space.add_collision_func(:harpoon, :ball) do |harpoon, ballShape|
      @ballToRemove = ballShape
    end

  end

  def update
    if Gosu.button_down? Gosu::KB_RIGHT
      @player.move(:right)
    elsif Gosu.button_down? Gosu::KB_LEFT
      @player.move(:left)
    else
      @player.move(:stop)
    end

    10.times do
      @space.step(@dt)
    end

    if @player.dead == true
      @space.remove_body(@player.shape.body)
      @space.remove_shape(@player.shape)
      @balls.each do |b|
        @space.remove_body(b.shape.body)
        @space.remove_shape(b.shape)
      end
    end

    if @harpoon != nil
      @harpoon.update()

      if @harpoon.shape.body.p.y <= 179
        @space.remove_body(@harpoon.shape.body)
        @space.remove_shape(@harpoon.shape)
        @harpoon = nil
      end

      if @ballToRemove != nil
        @balls.delete_if { |ball| ball.shape == @ballToRemove }
        @space.remove_body(@ballToRemove.body)
        @space.remove_shape(@ballToRemove)
        @ballToRemove = nil
        @space.remove_body(@harpoon.shape.body)
        @space.remove_shape(@harpoon.shape)
        @harpoon = nil
      end
    end

    if Gosu.button_down? Gosu::KB_SPACE
      if @harpoon == nil
        @harpoon = Harpoon.new(self, @player.shape.body.p.x)
      end
    end

    if Gosu.button_down? Gosu::KB_ESCAPE
      exit
    end
  end

  def draw
    @back[0].draw(0, 0, 1)
    @back2.draw(0, 0, 3)
    @player.draw

    @balls.each do |b| b.draw end

    if @harpoon != nil
      @harpoon.draw()
    end

    @font.draw("YeePang Jokoa", 10, 10, 0.1, 1.0, 1.0, Gosu::Color::YELLOW)
  end

end

YeePang.new.show
