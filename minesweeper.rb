require 'debugger'

class Minesweeper

  def initialize
    gameboard = build_gameboard(user_settings)
    adjacent_sq_counter(gameboard)
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

  def adjacent_sq_counter(gameboard)
    #debugger
    gameboard.each_with_index do |row, i|
      row.each_with_index do |square, j|
        next if square.bomb == false
        # neighbors
        if square != row.first
          row[j-1].adj_bomb += 1
        end
        if square != row.last
          row[j+1].adj_bomb += 1
        end
        # row above
        if row != gameboard.first
          if square != row.first
            gameboard[i-1][j-1].adj_bomb += 1
          end
          gameboard[i-1][j].adj_bomb += 1
          if square != row.last
            gameboard[i-1][j+1].adj_bomb += 1
          end
        end
        # row below
        if row != gameboard.last
          if square != row.first
            gameboard[i+1][j-1].adj_bomb += 1
          end
          gameboard[i+1][j].adj_bomb += 1
          if square != row.last
            gameboard[i+1][j+1].adj_bomb += 1
          end
        end
      end
    end
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
    @adj_bomb = 0
    @flagged = false
    @revealed = false
  end

end
