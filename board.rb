class Board

  def initialize(size)
    @grid = Array.new(size, " "){Array.new(size, " ")}
  end

  def display
    puts " 0 1 2 3 4 5 6 7 8"
    @grid.each_with_index do |line, i|
      print i
      line.each do |cell|
        print "#{cell} "
      end
      puts
    end
  end

  def place_move(pos, token)
    pos = pos.split(" ").map{|el| el.to_i}
    @grid[pos[0]][pos[1]] = token
  end


end
