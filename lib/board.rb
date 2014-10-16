class Board
  
  attr_accessor :board
  
  def initialize(size)
    make_board(size)
  end
  
  def [](pos)
    row, col = pos
    @board[row][col]
  end
  
  def won?
    @board.flatten.none? { |tile| tile.bomb != tile.flagged }
  end
  
  def lose?
     @board.flatten.any? { |tile| tile.bomb && tile.revealed }       
  end
    
  def display
    @board[0].count.times { |index1| print "   #{index1}" }
    puts
      
    @board.each_with_index do |row, index2|
      puts "----" * row.count + "--"
      print index2
      row.each { |tile| print "| #{tile.show} " }
      print "|"
      puts
    end
    puts "----" * @board[0].count + "-"
  end
  
  private
  
  def seed_bomb
    num = rand(100)
    return (num < 15) ? true : false
  end
  
  def make_board(size)
    @board = Array.new(size) { Array.new(size) }
    @board.count.times do |row|
      @board.count.times do |col|
        @board[row][col] = Tile.new(self, [row, col], bomb = seed_bomb)
      end
    end
  end

end