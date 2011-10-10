module Board
  module_function
    def generate
      [].tap do |grid|
        [5,4,3,3,2].each do |i|
          ship = rand_orientation_ship(i)

          loop { valid(ship,grid) ? break : ship = rand_orientation_ship(i) }

          grid << ship
        end
      end
    end

    def valid(ship,grid)
      !grid.any? { |grid_ship| intersect grid_ship, ship }
    end

    def intersect(ship,other_ship)
      ship_1 = coordinates_for(*ship)
      ship_2 = coordinates_for(*other_ship)
      ship_1.any? { |pos| ship_2.include? pos }
    end

    def coordinates_for(x,y,length,orientation)
      send(:"#{orientation}_coords",x,y,length)
    end

    def across_coords(x,y,length)
      (x..x+length).inject([]) { |a,x| a << [x,y] ; a }
    end

    def down_coords(x,y,length)
      (y..y+length).inject([]) { |a,y| a << [x,y] ; a }
    end

    def rand_orientation_ship(length)
      if rand(2) == 1
        ship_across(length)
      else
        ship_down(length)
      end
    end

    def ship_across(length)
      [constrained_by(length), any, length, :across]
    end
    def ship_down(length)
      [any, constrained_by(length), length, :down]
    end
    def constrained_by(length)
      rand(10-length)
    end
    def any
      rand(10)
    end
end

module Strategy
  module_function

  def generate
    @possible = all
  end

  def all
    (0...10).inject([]) { |a,x|  (0...10).each { |y| a << [x,y] }; a }
  end

  def for(state)
    next_position
  end

  def next_position
    random
  end

  def random
    @possible.shuffle!
    @possible.pop
  end

end

class DumbPlayer
  def name
    "Jon's Random Player"
  end

  def new_game
    Strategy.generate
    Board.generate
  end

  def take_turn(state, ships_remaining)
    Strategy.for state
  end
end
