#./lib/Chess
require 'yaml'

class Chess
  def initialize
    @board = self.board_init
    @turn = 1
    @king_coords = {1 => [7,4], -1 => [0,4]}
    @check_status = {1 => false, -1 => false}
    @history = []
    @king_or_rook_moved = {1 => false, -1 => false}
    @can_castle = {1 => [false,false], -1 => [false,false]}
    @game_status = nil
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

  def save
    fname = File.open('./lib/save_data.yml', 'w')
    YAML::dump(self,fname)
    fname.close
  end

  def load
    fname = File.open('./lib/save_data.yml', 'r')
    return YAML::load(fname)
  end

  # player enters column, then row
  def play(start, dest)
 
    return if self.game_over?;
    piece_id = read_board(start)
    return dest if piece_id.zero? || legal?(piece_id, start, dest) == false;

   
    dest.reverse
    write_board(dest, piece_id)
    write_board(start, 0)
    castle(1) if piece_id.abs == 6 && start[1] == 4 && dest[1] == 2;
    castle(2) if piece_id.abs == 6 && start[1] == 4 && dest[1] == 6;
    promote(dest) if piece_id.abs == 1 && ((dest[0] == 0 && @turn == 1) || (dest[0] == 7 && @turn == -1));
    @king_coords[@turn] = dest if piece_id.abs == 6;
    @check_status[-1 * @turn] = king_threat?(@king_coords[-1 * @turn], -1 * @turn)
    @history.append([start, dest])
    @king_or_rook_moved[@turn] = true if piece_id.abs == 6 || piece_id == 4;
    self.turn_switch
    write_game_status
  
  end

  def castle(direction)
    direction *= @turn
    case direction
    when 1
      write_board([7,0], 0)
      write_board([7,3], 4)
    when 2
      write_board([7,7],0)
      write_board([7,5], 4)
    when -1
      write_board([0,0], 0)
      write_board([0,3], -4)
    when -2
      write_board([0,7],0)
      write_board([0,5],-4)
    end
  end

  def turn_switch
    @turn = @turn == 1 ? -1 : 1
  end

  def read_board(pos,board = @board)
    return nil if pos.any? { |num| num > 7 || num.negative? }

    board[pos[0]][pos[1]]
  end

  def write_board(pos, val)
    return 'error' if pos.any? { |num| num > 7 || num.negative? };

    @board[pos[0]][pos[1]] = val
  end

  def legal?(piece_id, start, dest)
    return false if dest.any? { |coord| coord.negative? || coord > 7 } || (piece_id * @turn).negative?

    piece_case = piece_id.abs
    case piece_case
    when 1
      legality = pawn_moves(start).any? { |move| move == dest }
    when 2
      legality = bishop_moves(start).any? { |move| move == dest }
    when 3
      legality = knight_moves(start).any? { |move| move == dest }
    when 4
      legality = rook_moves(start).any? { |move| move == dest }
    when 5
      legality = queen_moves(start).any? { |move| move == dest }
    when 6
      castle_status()
      legality = king_moves(start).any? { |move| move == dest } && !king_threat?(dest)
    end
    if legality == false || king_threat_sim?(piece_id,dest,start)
      false
    else
      true
    end
  end

  def game_over?
    game_over = false
    game_over = true unless @game_status.nil?;
    if game_over
      case @game_status
      when 0
        puts 'stalemate'
      when -1
        puts 'black wins'
      when 1
        puts 'white wins'
      end
    end
    game_over
  end

  def write_game_status
    @game_status =  0 if repeat_moves?;
    return if any_legal_moves?;

    @game_status = king_threat? ? @turn * -1 : 0
  end

  def repeat_moves?
    repeats = false
    hist = @history.reverse
    repeats = true if hist[0] == hist[4] && hist[4] == hist[8] && hist[1] == hist[5] && hist[5] == hist[9] && hist.size > 10 ;
    repeats
  end

  def any_legal_moves?
    legal_moves = false
    saving_board = @board.dup
    saving_board.each_with_index do |row, i|
      break if legal_moves;

      row.each_with_index do |space, j|
        break if legal_moves;

        case space.abs
        when 0
          next
        when 1
          legal_moves = pawn_moves([i,j]).any? { |move| legal?(space,[i,j],move)}
        when 2
          legal_moves = bishop_moves([i,j]).any? { |move| legal?(space,[i,j],move)}
        when 3
          legal_moves = knight_moves([i,j]).any? { |move| legal?(space,[i,j],move)}
        when 4
          legal_moves = rook_moves([i,j]).any? { |move| legal?(space,[i,j],move)}
        when 5
          legal_moves = queen_moves([i,j]).any? { |move| legal?(space,[i,j],move)}
        when 6
          legal_moves = king_moves([i,j]).any? { |move| legal?(space,[i,j],move)}
        end
      end
    end
    legal_moves
  end

  def color(piece_id)
    piece_id / piece_id.abs
  end

  def king_threat_sim?(piece_id,dest,start)
    color = color(piece_id)
    false_board = @board.dup
    false_board[start[0]][start[1]] = 0
    false_board[dest[0]][dest[1]] = piece_id
    kt = king_threat?(@king_coords[color], color, false_board)
    false_board[start[0]][start[1]] = piece_id
    false_board[dest[0]][dest[1]] = 0
    kt
  end

  def pawn_moves(start)
    moves = []
    row = start[0]
    col = start[1]
    one_ahead = row - 1 * @turn
    two_ahead = row - 2 * @turn
    # two moves at start
    moves.append([two_ahead, col]) if ((row == 6 && @turn == 1) || (row == 1 && @turn == -1)) && piece_in_way?([one_ahead, col]) == false && piece_in_way?([two_ahead, col]) == false;
    # move one space
    moves.append([one_ahead, col]) if piece_in_way?([one_ahead, col]) == false;
    # attack left
    moves.append([one_ahead, col-1]) if piece_in_way?([one_ahead, col - 1]) && enemey?([one_ahead, col-1]);
    # attack right
    moves.append([one_ahead, col+1]) if piece_in_way?([one_ahead, col + 1]) && enemey?([one_ahead, col + 1]);
    moves
  end

  def bishop_moves(start)
    [] + scan_direction(start, -1, -1) +
      scan_direction(start, -1, 1) +
      scan_direction(start, 1, -1) +
      scan_direction(start, 1, 1)
  end

  def knight_moves(start)
    moves = []
    row, col = start
    moves.append([row - 1, col + 2]) if !piece_in_way?([row - 1, col + 2]) || enemey?([row - 1, col + 2]);
    moves.append([row - 1, col - 2]) if !piece_in_way?([row - 1, col - 2]) || enemey?([row - 1, col - 2]);
    moves.append([row + 1, col + 2]) if !piece_in_way?([row + 1, col + 2]) || enemey?([row + 1, col + 2]);
    moves.append([row + 1, col - 2]) if !piece_in_way?([row + 1, col - 2]) || enemey?([row + 1, col - 2]);
    moves.append([row - 2, col + 1]) if !piece_in_way?([row - 2, col + 1]) || enemey?([row - 2, col + 1]);
    moves.append([row - 2, col - 1]) if !piece_in_way?([row - 2, col - 1]) || enemey?([row - 2, col - 1]);
    moves.append([row + 2, col + 1]) if !piece_in_way?([row + 2, col + 1]) || enemey?([row + 2, col + 1]);
    moves.append([row + 2, col - 1]) if !piece_in_way?([row + 2, col - 1]) || enemey?([row + 2, col - 1]);
    moves
  end

  def rook_moves(start)
    [] + scan_direction(start, -1, 0) +
      scan_direction(start, 1, 0) +
      scan_direction(start, 0, -1) +
      scan_direction(start, 0, 1)
  end

  def queen_moves(start)
    [] + rook_moves(start) + bishop_moves(start)
  end

  def king_moves(start)
    moves = []
    row, col = start
    moves.append([row - 1, col]) if !piece_in_way?([row - 1, col]) || enemey?([row - 1, col]);
    moves.append([row + 1, col]) if !piece_in_way?([row + 1, col]) || enemey?([row + 1, col]);
    moves.append([row - 1, col + 1]) if !piece_in_way?([row - 1, col + 1]) || enemey?([row - 1, col + 1]);
    moves.append([row - 1, col - 1]) if !piece_in_way?([row - 1, col - 1]) || enemey?([row - 1, col - 1]);
    moves.append([row + 1, col + 1]) if !piece_in_way?([row + 1, col + 1]) || enemey?([row + 1, col + 1]);
    moves.append([row + 1, col - 1]) if !piece_in_way?([row + 1, col - 1]) || enemey?([row + 1, col - 1]);
    moves.append([row, col + 1]) if !piece_in_way?([row, col + 1]) || enemey?([row, col + 1]);
    moves.append([row, col - 1]) if !piece_in_way?([row, col - 1]) || enemey?([row, col - 1]);
    moves.append([row, col + 2]) if @can_castle[@turn][1];
    moves.append([row, col - 2]) if @can_castle[@turn][0];
    

    moves
  end

  def castle_status
    row = @turn == 1 ? 7 : 0
    left = [[row, 3], [row, 2], [row, 1]]
    right = [[row, 5], [row, 6]]
    @can_castle[@turn][0] = true if left.all? { |tile| !piece_in_way?(tile) && !king_threat?(tile) && !@king_or_rook_moved[@turn] };
    @can_castle[@turn][1] = true if right.all? { |tile| !piece_in_way?(tile) && !king_threat?(tile) && !@king_or_rook_moved[@turn] };
    @can_castle[@turn]
  end

  def scan_direction(start, row_d = -1, col_d = 0)
    moves = []
    scan = [start[0]+row_d, start[1]+col_d]
    while piece_in_way?(scan) == false
      moves.append(scan) if piece_in_way?(scan) == false;
      scan = [scan[0]+row_d, scan[1]+col_d]
    end
    moves.append(scan) if enemey?(scan);
    moves
  end

  def piece_in_way?(dest)
    return true if read_board(dest).nil?;

    read_board(dest).nonzero? || dest.any? { |num| num > 7 || num.negative? }
  end

  def enemey?(dest)
    return false if read_board(dest) == nil;

    (read_board(dest) * @turn).negative?
  end

  def promote(dest)
    piece_id = 0
    pieces = [2,3,4,5]
    until pieces.include?(piece_id)
      puts 'enter the id of the piece you would like to promote to'
      puts '2 = bishop, 3 = knight, 4 = rook, 5 = queen'
      piece_id = gets.chomp.to_i
      piece_id = 0 if piece_id.class != Integer;
    end
    write_board(dest,piece_id * @turn)
  end

  def king_threat?(pos = @king_coords[@turn], color = @turn, board = @board)
    
    threat = false
    if piece_in_set?([[pos[0] - color, pos[1] + 1], [pos[0] - color, pos[1] - 1]], -1 * color, board) ||
                     piece_in_set?(bishop_moves(pos), -2 * color, board) ||
                     piece_in_set?(knight_moves(pos), -3 * color, board) ||
                     piece_in_set?(rook_moves(pos), -4 * color, board) ||
                     piece_in_set?(queen_moves(pos), -5 * color, board) ||
                     piece_in_set?(king_moves(pos), -6 * color, board)
      threat = true
    end
    threat
  end

  def piece_in_set?(moves,piece,board = @board)
    pieces = []
    moves.each { |move| pieces.append(read_board(move, board)) }
    pieces.include?(piece)
  end
end