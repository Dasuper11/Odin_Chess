#./lib/Chess
class Chess
  def initialize
    @board = self.board_init
    @turn = 1
  end

  def board_init
    # pawn = 1, bishop = 2, knight = 3, rook = 4, queen = 5, king = 6
    [[-4, -3, -2, -5, -6, -2, -3, -4],
     [-1, -1, -1, -1, -1, -1, -1, -1],
     [0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0, 0, 0, 0],
     [1, 1, 1, 1, 1, 1, 1, 1],
     [4, 3, 2, 5, 6, 2, 3, 4]]
  end

  # player enters column, then row
  def play(start, dest) 
    piece_id = @board[start[1]][start[0]]
    return nil if piece_id.zero? 

    legal?(piece_id,start,dest)
  end

  def turn_switch
    @turn = @turn == 1 ? -1 : 1
  end

  def legal?(piece_id,start,dest)

  end

  def promote

  end

  def king_threat?

  end
end
