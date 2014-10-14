class Tile
  attr_reader :bomb, :flagged, :revealed
  
  def initialize(board, position, bomb = false)
    @board = board
    @position = position
    @flagged = false
    @revealed = false
    @bomb = bomb
  end
  
  def reveal
    return self if revealed || flagged
    neighbors = self.neighbors_list
    @revealed = true                
    neighbors.each(&:reveal) if self.neighbors_bomb_count == 0                               
  end
  
  def neighbors_list 
    r = @position[0]
    c = @position[1]
    upper_bound = @board.board.count - 1
	rows, columns = [r+1, r-1, r], [c+1, c-1, c]
    rows.product(columns)[0..-2].select {|pos| pos[0].between?(0, upper_bound) && pos[1].between?(0, upper_bound)}.map {|pos| @board[pos]}
  end
  
  def neighbors_bomb_count
    self.neighbors_list.select(&:bomb).count
  end
  
  def show
    return :F if flagged
    if revealed
      return :B if bomb
      count = neighbors_bomb_count
      return :_ if count == 0
      return count
    else
      return :*
    end
  end
  
  def flag
    @flagged = !@flagged
  end

end

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
    @board.flatten.none? {|tile| tile.bomb != tile.flagged}
  end
  
  def lose?
     @board.flatten.any? {|tile| tile.bomb && tile.revealed}       
  end
    
  def display
    @board[0].count.times {|index1| print "   #{index1}"}
    puts
      
    @board.each_with_index do |row, index2|
      puts "----" * row.count + "--"
      print index2
      row.each {|tile| print "| #{tile.show} "}
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

class Game
  def initialize(n = 9)
    @board = Board.new(n)
  end
  
  def play
    display
    pos = [0, 0]
    until over?
      pos, action = get_input
      move(action, pos)
      display
    end
    
    puts @board.lose? ? "You hit the bomb!" : "You Win!"   
  end
  
  private
  
  def get_input
    puts "Please select your cooridinates row, col"
    location = gets.chomp.split(",").map(&:to_i)
    puts "please choose an action (flag or reveal)"
    action = gets.chomp
    [location, action]
  end
  
  def move(action, location)
    action == "flag" ? @board[location].flag : @board[location].reveal
  end
  
  def display
    @board.display
  end
  
  def over?
    return true if @board.won? || @board.lose? 
    false
  end  
end

g = Game.new(5)
g.play