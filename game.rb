require_relative 'board.rb'
require_relative 'player.rb'

class Game

  HANDICAP = 5.5

  def initialize(name1, name2, board_size)
    @board_size = board_size
    @player1, @player2 = Player.new(name1, 0, "X"), Player.new(name1, HANDICAP, "O")
    @current_player = @player1
    @board = Board.new(board_size)
  end

  def play
    until game_over?
      puts "It's #{@current_player.name}'s turn"
      @board.display
      move = nil
      until legal_move?(move)
        puts "Enter move (e.g. '3 1'):"
        move = gets.chomp
      end
        @board.place_move(move, @current_player.token)
      switch_current_player
    end
  end

  def game_over?
    false
  end

  def legal_move?(move)
    return false if move.nil?
    move = move.split(" ").map{|el| el.to_i}
    if move.length != 2 ||
       out_of_bounds?(move) ||
       @board.grid[move[0]][move[1]] != " "
        return false
    end
    true
  end



  def find_groups
    tokens = token_coords
    groups = []
    token_coords.each do |token_coord|
      groups.each do |group|
        if belongs_to_group?(token_coord, group)
          group << token_coord
        else
          groups << token_coord
        end
      end
    end
    groups
  end




  private

  def belongs_to_group(token_coord, group)
    group.each do |token|
      return true if bordering?(token_coord, token)
    end
    false
  end

  def bordering?(coord1, coord2)
    if coord1[0] == coord2[0] &&
      (coord1[1] - coord2[1]).abs == 1
      return true
    elsif coord1[1] == coord2[1] &&
      (coord1[0] - coord2[0]).abs == 1
      return true
    end
      false
  end

  def switch_current_player
    if @current_player == @player1
       @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def all_coordinates
    coords = []
    (0..@board_size).each do |x|
      (0..@board_size).each do |y|
        coords << [x, y]
      end
    end
    coords
  end

  def token_coords
    token_coords = []
    all_coordinates.each do |coords|
      if @board.grid[coords[0]][coords[1]] != " "
        token_coords << coords
      end
    end
    token_coords
  end

  def neighboring_cells(x, y)
    neighbors = {
      "edge" => 0,
      "friendly" => 0,
      "enemy" => 0,
      "blank" => 0
    }
    neighbor_coords = [
      [x-1, y],
      [x, y-1],
      [x, y+1],
      [x+1, y],
     ]
    neighbor_coords.each do |coords|
      neighbors[type(coords)] += 1
    end
    neighbors
  end

  def type(coords)
    if out_of_bounds?(coords)
      return "edge"
    elsif friendly?(coords)
      return "friendly"
    elsif blank?(coords)
      return "blank"
    else
      "enemy"
    end
  end

  def out_of_bounds?(coords)
    coords[0] < 0 ||
    coords[1] < 0 ||
    coords[0] >= @board_size  ||
    coords[1] > @board_size
  end

  def friendly?(coords)
    @board.grid[coords[0]][coords[1]] == @current_player.token
  end

  def blank?(coords)
    @board.grid[coords[0]][coords[1]] == " "
  end

end


game = Game.new("John", "Jane", 9)
game.play
