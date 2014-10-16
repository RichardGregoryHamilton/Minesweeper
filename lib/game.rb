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