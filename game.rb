require_relative 'board.rb'
require_relative 'player.rb'
require 'byebug'
class Game

  HANDICAP = 5.5
  $pass_count = 0

  def initialize(name1, name2, board_size)
    @board_size = board_size
    @player1, @player2 = Player.new(name1, 0, "\u25cf".encode('utf-8')), Player.new(name2, HANDICAP, "\u25ef".encode('utf-8'))
    @current_player = @player1
    @board = Board.new(board_size)
  end

  def play
    until game_over?
      stats
      @board.display
      move = nil
      until legal_move?(move)
        puts "Enter move (e.g. '3 1') or 'pass':"
        move = gets.chomp
      end
       unless move == "pass"
         @board.place_move(move, @current_player.token)
         $pass_count = 0
       else
         $pass_count += 1
       end
      kill_dead_groups
      switch_current_player
    end
    puts "Game Over!"
  end

  def stats
    puts "-----------------------------------"
    puts "Score: #{@player1.name}: #{@player1.score} - #{@player2.name}: #{@player2.score}"
    puts
    puts "It's #{@current_player.name}'s turn:"
    puts
  end

  def game_over?
    if $pass_count == 2
      return true
    else
      false
    end
  end

  def legal_move?(move)
    return true if move == "pass"
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
      accounted_for = false
      groups.each_with_index do |group, i|
        if belongs_to_group?(token_coord, group)
          accounted_for = true
          groups[i] += [token_coord]
        end
      end
      groups << [token_coord] if accounted_for == false

    end
    groups
  end

  def kill_dead_groups
    groups = find_groups
    groups.each do |group|
      if surrounded?(group)
        @board.delete(group)
        update_score(group)
      end
    end
  end

  def update_score(group)
    if @board.grid[group[0][0]][group[0][1]] == @player1.token
      @player2.score += group.length
    else
      @player1.score += group.length
    end
  end

  def surrounded?(group)
    group.each do |cell|
      neighbors = neighboring_cells(cell[0], cell[1])
      return false if neighbors["blank"] >= 1
    end
    true
  end

  private

  def belongs_to_group?(token_coord, group)
    group.each do |token|
      if bordering?(token_coord, token) &&
        @board.grid[token_coord[0]][token_coord[1]] == @board.grid[token[0]][token[1]]
        return true
      end
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
    (0...@board_size).each do |x|
      (0...@board_size).each do |y|
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



puts "Enter player1's name: "
name1 = gets.chomp
puts "Enter player2's name: "
name2 = gets.chomp
puts "Enter board size (19, 13 or 9 is recommended):"
size = gets.chomp.to_i
game = Game.new(name1, name2, size)
game.play
