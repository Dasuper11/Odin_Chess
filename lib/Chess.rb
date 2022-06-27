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

  def display
    piece_dictionary = {0 => '* ', -1 => "\u2659 ", -2 => "\u2657 ", -3 => "\u2658 ", -4 => "\u2656 ", -5 => "\u2655 ", -6 => "\u2654 ",
                        1 => "\u265F ", 2 => "\u265D ", 3 => "\u265E ", 4 => "\u265C ", 5 => "\u265B ", 6 => "\u265A "}
    @board.each do |row|
      line = ''
      row.each do |piece|
        line << piece_dictionary[piece]
      end
      puts line
    end
  end

  # player enters column, then row
  def play(start, dest)
    piece_id = read_board(start)
    return dest if piece_id.zero? || legal?(piece_id, start, dest) == false
    dest.reverse
    write_board(dest, piece_id)
    write_board(start, 0)
    #promote(dest) if piece_id.abs == 1 && ()
    self.turn_switch
  end

  def turn_switch
    @turn = @turn == 1 ? -1 : 1
  end

  def read_board(pos)
    return nil if pos.any? { |num| num > 7 || num.negative? }

    @board[pos[0]][pos[1]]
  end

  def write_board(pos, val)
    return 'error' if pos.any? { |num| num > 7 || num.negative? }

    @board[pos[0]][pos[1]] = val
  end

  def legal?(piece_id, start, dest)
    return false if dest.any? { |coord| coord.negative? || coord > 7 } || (piece_id * @turn).negative?

    piece_id = piece_id.abs
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
    row = start[0]
    col = start[1]
    one_ahead = row - 1 * @turn
    two_ahead = row - 2 * @turn
    # two moves at start
    moves.append([two_ahead, col]) if ((row == 6 && @turn == 1) || (row == 1 && @turn == -1)) &&
                                      piece_in_way?([one_ahead, col]) == false &&
                                      piece_in_way?([two_ahead, col]) == false
    # move one space
    moves.append([one_ahead, col]) if piece_in_way?([one_ahead, col]) == false
    # attack left
    moves.append([one_ahead, col-1]) if piece_in_way?([one_ahead, col-1]) &&
                                       self.enemey?([one_ahead, col-1])
    # attack right
    moves.append([one_ahead, col+1]) if piece_in_way?([one_ahead, col+1]) &&
                                       self.enemey?([one_ahead, col+1])
    return moves
  end

  def bishop_moves(start)
   moves = []

  end

  def knight_moves(start)
    moves = []
    row, col = start
    moves.append([row - 1, col + 2]) if piece_in_way?([row - 1, col + 2]) == false || enemey?([row - 1, col + 2])
    moves.append([row - 1, col - 2]) if piece_in_way?([row - 1, col - 2]) == false || enemey?([row - 1, col - 2])
    moves.append([row + 1, col + 2]) if piece_in_way?([row + 1, col + 2]) == false || enemey?([row + 1, col + 2])
    moves.append([row + 1, col - 2]) if piece_in_way?([row + 1, col - 2]) == false || enemey?([row + 1, col - 2])
    moves.append([row - 2, col + 1]) if piece_in_way?([row - 2, col + 1]) == false || enemey?([row - 2, col + 1])
    moves.append([row - 2, col - 1]) if piece_in_way?([row - 2, col - 1]) == false || enemey?([row - 2, col - 1])
    moves.append([row + 2, col + 1]) if piece_in_way?([row + 2, col + 1]) == false || enemey?([row + 2, col + 1])
    moves.append([row + 2, col - 1]) if piece_in_way?([row + 2, col - 1]) == false || enemey?([row + 2, col - 1])
    moves
  end

  def rook_moves(start)

  end

  def queen_moves(start)

  end

  def king_moves(start)

  end

  def scan_direction(start, row_d = -1, col_d = 0)
    moves = []
    scan = [start[0]+row_d, start[1]+col_d]
    while piece_in_way?(scan) == false
      moves.append(scan)
      scan = [scan[0]+row_d, scan[1]+col_d]
    end
    moves.append(scan) if enemey?(scan)
    moves
  end

  def piece_in_way?(dest)
    return true if read_board(dest).nil?

    read_board(dest).nonzero? || dest.any? { |num| num > 7 || num.negative? }
  end

  def enemey?(dest)
    return false if read_board(dest).nil?

    (read_board(dest) * @turn).negative?
  end

  def promote

  end

  def king_threat?

  end
end
