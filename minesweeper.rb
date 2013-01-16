require 'debugger'

class Minesweeper

  DELTAS = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]

  def initialize
    gameboard = build_gameboard(user_settings)
    print_board(gameboard)
  end

  def user_settings
    puts "Minesweeper grid size? 1 for 9x9, 2 for 16x16"
    size = gets.chomp.to_i
    unless size == 1 || size == 2
      puts "invalid entry"
      user_settings
    end
    size
  end
  # gameboard methods
  def build_gameboard(size)
    n, m = 0
    n, m = 9, 10 if size == 1
    n, m = 16, 40 if size == 2
    gameboard = Array.new(n) do
      Array.new(n) { Square.new }
    end
    #debugger
    set_bomb(gameboard, m)
    fringe_sq_iterator(gameboard)
    gameboard
  end

  def set_bomb(gameboard, bomb_count)
    bombs = 0
    while true
      return if bombs == bomb_count
      row = gameboard.sample
      square = row.sample
      if square.bomb == false
        square.bomb = true
        bombs += 1
      end
    end
  end

  def print_board(gameboard)
    gameboard.each do |row|
      row.each do |square|
        if square.bomb == true
          print "X"
          next
        elsif square.adj_bomb == 0
          print "*"
          next
        else
          print square.adj_bomb
        end
      end
      puts "\n"
    end
  end

  def fringe_sq_iterator(gameboard)
    gameboard.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square.bomb == true
          adjacents = adjacent_squares(gameboard, [i, j])
          adjacents.each do |coordinates|
            gameboard[coordinates[0]][coordinates[1]].adj_bomb += 1
          end
        end
      end
    end
  end

  def adjacent_squares(gameboard, coordinates)
    adjacents = DELTAS.map do |coord|
      x = coord[0] + coordinates[0]
      y = coord[1] + coordinates[1]
      [x, y]
    end
    selected = adjacents.select do |coord|
      coord[0] < gameboard.length && coord[0] > 0 && coord[1] < gameboard.length && coord[1] > 0
    end
    p selected
    selected
  end

  # user methods

  def move
    puts "Type 'R' and your coordinates to reveal (ex: R 4, 5)"
    puts "Type 'F' and your coordinates to flag"
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
    @adj_bomb = 0
    @flagged = false
    @revealed = false
  end

end
