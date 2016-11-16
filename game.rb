require_relative 'board.rb'

class Game

  def initialize(player1, player2, board_size)
    @board_size = board_size
    @player1, @player2 = player1, player2
    @current_player = player1
    @board = Board.new(board_size)
  end

  def play
    until game_over?
      puts "It's #{@current_player}'s turn"
      @board.display
      puts "Enter move (e.g. '3 1'):"
      move = gets.chomp
      @board.place_move(move, @current_player)
      @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
    end
  end

  def game_over?
    false
  end


  private

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
    @board.grid[coords[0]][coords[1]] == @current_player
  end

  def blank?(coords)
    @board.grid[coords[0]][coords[1]] == " "
  end

end


game = Game.new("X", "O", 9)
game.play
