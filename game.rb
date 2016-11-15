require_relative 'board.rb'

class Game

  def initialize(player1, player2, board_size)

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


end


game = Game.new("X", "O", 9)
game.play
