class Minesweeper

  def initialize

  end

  def user_settings
    puts "Minesweeper grid size? 1 for 9x9, 2 for 16x16"
    size = gets.chomp.to_i
    if size != 1 || size != 2
      puts "invalid entry"
      user_settings
    end
    size
  end
  # gameboard methods
  def gameboard(size)
    n, m = 0
    gameboard = []
    n = 9, m = 10 if size == 1
    n = 16, m = 40 if size == 2
    n.times do
      gameboard << [Square.new] * n
    end
    m.times do
      set_bomb(gameboard)
    end
  end

  def set_bomb(gameboard)
    row = gameboard.sample
    square = row.sample
    if square.bomb == true
      set_bomb(gameboard)
    else
      square.bomb = true
    end
  end

  def set_square_types
    # set the bombs
    # iterate the adj_bomb count accordingly
  end

  # user methods

  def reveal
    puts "What square do you want to reveal?"
    coordinates = gets.chomp
    if coordinates[:bomb] == true
      puts "You lost!"
      return
    end
  end

  def flag_bomb(coordinates)
    #just allows a user to see flags of where he thinks bombs are
  end

  def check_coordinate(coordinates)
    if coordinates[:bomb] == true
      puts "You lost!"
      return
    end
  end
end
class Square

  attr_accessor :bomb, :adj_bomb, :flagged, :revealed

  def initialize
    @bomb = false
    @adj_bomb = nil
    @flagged = false
    @revealed = false
  end

end
