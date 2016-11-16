class Board

  attr_accessor :grid

  def initialize(size)
    @grid = Array.new(size, " "){Array.new(size, " ")}
  end

  def display

    print "  "
    @grid.each_index do |i|
      if i/10 != 0
        print "#{i/10} "
      else
        print "  "
      end
    end
    puts

    print "  "
    @grid.each_index do |i|
      print "#{i%10} "
    end
    puts
    @grid.each_with_index do |line, i|
      print "#{i} "
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

  def delete_cell(coord)
    @grid[coord[0]][coord[1]] = " "
  end

  def delete(group)
    group.each do |coord|
      delete_cell(coord)
    end
  end


end
