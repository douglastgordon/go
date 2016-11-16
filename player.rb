class Player

  attr_reader :name, :token
  attr_accessor :score

  def initialize(name, score, token)
    @name = name
    @score = score
    @token = token
  end

end
