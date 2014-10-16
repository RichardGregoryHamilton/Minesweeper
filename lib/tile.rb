class Tile
  attr_reader :bomb, :flagged, :revealed
  
  def initialize(board, position, bomb = false)
    @board    = board
    @position = position
    @flagged  = false
    @revealed = false
    @bomb     = bomb
  end
  
  def reveal
    return self if revealed || flagged
    neighbors = self.neighbors_list
    @revealed = true                
    neighbors.each(&:reveal) if self.neighbors_bomb_count == 0                               
  end
  
  def neighbors_list 
    r           = @position[0]
    c           = @position[1]
		rows        = [r+1, r-1, r]
		columns     = [c+1, c-1, c]
    upper_bound = @board.board.count - 1
    positions   = rows.product(columns)[0..-2].select do |pos| 
			[0,1].all?{ |i| pos[i].between?(0, upper_bound) }
		end
		positions.map { |pos| @board[pos] }
  end
  
  def neighbors_bomb_count
    self.neighbors_list.select(&:bomb).count
  end
  
  def show
    return :F if flagged
    if revealed
      return :B if bomb
      return :_ if neighbors_bomb_count.zero?
      return count
    else
      return :*
    end
  end
  
  def flag
    @flagged = !@flagged
  end

end