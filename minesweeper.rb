require 'debugger'

class Minesweeper

  attr_reader :gameboard

  DELTAS = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]

  def user_settings
    puts "Minesweeper grid size? 1 for 9x9, 2 for 16x16"
    size = gets.chomp.to_i
    unless size == 1 || size == 2
      puts "invalid entry"
      user_settings
    end
    size
  end

  def play
    build_gameboard(user_settings)
    until game_over? || won?
      print_board
      player_move = move
      check_coordinate(player_move)
    end
    print_board
    puts "GAME OVER!" if game_over?
    puts "YOU WON!" if won?
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

  def game_over?
    @gameboard.each do |row|
      row.each do |square|
        return true if square.bomb == true && square.revealed == true
      end
    end
    false
  end

  def won?
    correct_guesses = 0
    @gameboard.each do |row|
      row.each do |square|
        correct_guesses += 1 if square.bomb == true && square.flagged == true
      end
    end
    return true if correct_guesses == @bomb_count
    false
  end

  # gameboard methods
  def build_gameboard(size)
    n, m = 0
    n, m = 9, 10 if size == 1
    n, m = 16, 40 if size == 2
    @gameboard = Array.new(n) do
      Array.new(n) { Square.new }
    end
    @bomb_count = m
    set_bomb
    fringe_sq_iterator
  end

  def set_bomb
    bombs = 0
    until bombs == @bomb_count
      row = @gameboard.sample
      square = row.sample
      if square.bomb == false
        square.bomb = true
        bombs += 1
      end
    end
  end

  def print_board
    @gameboard.each do |row|
      row.each do |square|
        if square.revealed == true || square.flagged == true
          if square.flagged == true
            print " F "
            next
          elsif square.bomb == true
            print " X "
            next
          elsif square.adj_bomb == 0
            print " - "
          else
            print " #{square.adj_bomb} "
          end
        else
          print " * "
        end
      end
      print "\n"
    end
  end

  def fringe_sq_iterator
    @gameboard.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if square.bomb == true
          adjacents = adjacent_squares([i, j])
          adjacents.each do |coordinates|
            @gameboard[coordinates[0]][coordinates[1]].adj_bomb += 1
          end
        end
      end
    end
  end

  def adjacent_squares(coordinates)
    adjacents = DELTAS.map do |coord|
      x = coord[0] + coordinates[0]
      y = coord[1] + coordinates[1]
      [x, y]
    end
    selected = adjacents.select do |coord|
      coord[0] < @gameboard.length && coord[0] > 0 && coord[1] < @gameboard.length && coord[1] > 0
    end
    selected
  end

  # user methods

  def move
    puts "Type 'R' and your coordinates to reveal (ex: R 4 5)"
    puts "Type 'F' and your coordinates to flag (ex: F 4 5)"
    move = gets.chomp.split(' ')
    [move[0].downcase, [move[1].to_i, move[2].to_i]]
  end

  def check_coordinate(move)
    type = move[0]
    coord = move[1]
    tile = @gameboard[coord[0]][coord[1]]
    if type == 'r'
      if tile.bomb == true
        tile.revealed = true
      else
        reveal(coord)
      end
    elsif type == 'f'
      tile.flagged = true
    end
  end

  def reveal(move)
    queue = [move]
    checked = []

    while move = queue.shift
      @gameboard[move[0]][move[1]].revealed = true
      checked << move
      to_check = adjacent_squares(move)
      to_check.each do |coord|
        if @gameboard[coord[0]][coord[1]].bomb == false
          queue << coord
        end
      end
      queue.delete_if { |coord| checked.include?(coord) }
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
