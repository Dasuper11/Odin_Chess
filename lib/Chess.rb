#./lib/Chess
class Chess
  def initialize
    @board = self.board_init
    @turn = 1
    @white_king_coord = [7, 4]
    @black_king_coord = [0, 4]
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
    return 'invalid move' if piece_id.zero? || legal?(piece_id, start, dest) == false

    @board[dest[1]][dest[0]] = piece_id
    @board[start[1]][start[0]] = 0
    self.turn_switch
  end

  def turn_switch
    @turn = @turn == 1 ? -1 : 1
  end

  def legal?(piece_id, start, dest)
    return false if dest.any? { |coord| coord.negative? || coord > 7 }

    piece_id = abs(piece_id)
    case piece_id
    when 1
      return pawn_moves(start).any? { |move| move == dest }
    when 2
      return bishop_moves(start).any? { |move| move == dest }
    when 3
      return knight_moves(start).any? { |move| move == dest }
    when 4
      return rook_moves(start).any? { |move| move == dest }
    when 5
      return queen_moves(start).any? { |move| move == dest }
    when 6
      return king_moves(start).any? { |move| move == dest }
    end
  end

  def pawn_moves(start)
    moves = []
    row = start[1]
    col = start[0]
    one_ahead = row - 1 * @turn
    two_ahead = row - 2 * @turn
    # two moves at start
    moves.append([col, two_ahead]) if ((row == 6 && @turn == 1) || (row == 1 && @turn == -1)) &&
                                      piece_in_way?([col, one_ahead]) == false &&
                                      piece_in_way?([col, two_ahead]) == false
    # move one space
    moves.append([col, one_ahead]) if piece_in_way?([col, one_ahead]) == false
    # attack left
    moves.append([col-1,one_ahead]) if piece_in_way?([col-1, one_ahead]) &&
                                       self.enemey?
    # attack right
    moves.append([col+1,one_ahead]) if piece_in_way?([col+1, one_ahead]) &&
                                       self.enemey?
    return moves
  end

  def bishop_moves(start)

  end

  def knight_moves(start)

  end

  def rook_moves(start)

  end

  def queen_moves(start)

  end

  def king_moves(start)

  end

  def piece_in_way?(dest)
    @board[dest[1]][dest[0]].nonzero? || dest.any? { |num| num > 7 || num.negative? }
  end

  def enemey?(dest)
    (@board[dest[1]][dest[0]] * @turn).negative?
  end

  def promote

  end

  def king_threat?

  end
end
