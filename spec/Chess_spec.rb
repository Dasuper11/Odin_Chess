#./lib/Chess_spec
require './lib/Chess'

describe '#Chess' do
  context 'when moving pawn' do
    it 'can move forward one' do
      game = Chess.new
      game.play([6,3],[5,3])
      expect(game.read_board([5,3])).to eql(1)
    end

    it 'can move forward two on from initial row' do
      game = Chess.new
      game.play([6,3],[4,3])
      expect(game.read_board([4,3])).to eql(1)
    end

    it 'changes turn' do
      game = Chess.new
      game.play([6,3],[5,3])
      expect(game.instance_variable_get('@turn')).to eql(-1)
    end

    it 'can take enemey piece diagonally' do
      game = Chess.new
      game.play([6,3],[4,3])
      game.play([1,2],[3,2])
      game.play([4,3],[3,2])
      expect(game.read_board([3,2])).to eql(1)
    end

    it 'cannot move forward into another piece' do
      game = Chess.new
      game.play([6,3],[4,3])
      game.play([1,3],[3,3])
      game.play([4,3],[3,3])
      expect(game.instance_variable_get('@turn')).to eql(1)
    end

    it 'cannot move two spaces after first move' do
      game = Chess.new
      game.play([6,3],[5,3])
      game.play([1,2],[3,2])
      game.play([5,3],[3,3])
      expect(game.instance_variable_get('@turn')).to eql(1)
    end

    it 'cannot move another players piece' do
      game = Chess.new
      game.play([1,2],[3,2])
      expect(game.instance_variable_get('@turn')).to eql(1)
    end

    it "promotes" do
      game = Chess.new

    end
  end

  context 'when moving knight' do
    it 'moves in correct pattern' do
      game = Chess.new
      game.play([7,1],[5,0])
      expect(game.read_board([5,0])).to eql(3)
    end

    it 'can attack enemey piece' do
      game = Chess.new
      game.play([7,1],[5,0])
      game.play([1,1],[3,1])
      game.play([5,0],[3,1])
      expect(game.read_board([3,1])).to eql(3)
    end
    
    it 'cannot move onto friendly piece' do
      game = Chess.new
      game.play([7,1],[6,3])
      expect(game.instance_variable_get('@turn')).to eql(1)
    end

    it 'cannot move off board' do
      game = Chess.new
      game.play([7,1],[9,0])
      expect(game.instance_variable_get('@turn')).to eql(1)
    end
  end

  context 'when moving king' do
    it 'can move forward into open file' do
      game = Chess.new
      game.play([6,4],[4,4])
      game.play([1,4],[3,4])
      game.play([7,4],[6,4])
      expect(game.read_board([6,4])).to eql(6)
      
    end

    it 'cannot move into threatened position' do
      game = Chess.new
      game.play([6,4],[5,4])
      game.play([1,1],[2,1])
      game.play([6,7],[5,7])
      game.play([0,2],[2,0])
      game.play([7,4],[6,4])
      expect(game.instance_variable_get('@turn')).to eql(1)
      expect(game.read_board([6,4])).to eql(0)
    end

    it 'can castle' do
      game = Chess.new
      game.write_board([7,1],0)
      game.write_board([7,2],0)
      game.write_board([7,3],0)
      game.play([7,4],[7,2])
      expect(game.instance_variable_get('@turn')).to eql(-1)
    end

    it 'can castle if king or rook has moved' do
      game = Chess.new
      game.write_board([7,1],0)
      game.write_board([7,2],0)
      game.write_board([7,3],0)
      game.play([7,0],[7,1])
      game.play([1,0],[2,0])
      game.play([7,0],[7,1])
      game.play([2,0],[3,0])
      game.play([7,4],[7,2])
      expect(game.instance_variable_get('@turn')).to eql(1)
    end

    it 'cannot reveal king to enemey' do
      game = Chess.new
      game.write_board([5,4],4)
      game.play([6,3],[4,3])
      game.play([1,4],[3,4])
      game.play([6,0],[5,0])
      game.play([3,4],[4,3])
      expect(game.instance_variable_get('@turn')).to eql(-1)
    end

    it 'when checkmated, game ends' do
      game = Chess.new
      game.play([6,4],[5,4])
      game.play([1,5],[2,5])
      game.play([7,3],[5,5])
      game.play([1,6],[3,6])
      game.play([5,5],[3,7])
      expect(game.instance_variable_get('@game_status')).to eql(1)
    end

    it 'when moves repeated 3 times, stalemate' do
      game = Chess.new
      game.play([7,1],[5,0])
      game.play([0,1],[2,0])
      game.play([7,0],[7,1])
      game.play([0,0],[0,1])
      game.play([7,1],[7,0])
      game.play([0,1],[0,0])
      game.play([7,0],[7,1])
      game.play([0,0],[0,1])
      game.play([7,1],[7,0])
      game.play([0,1],[0,0])
      game.play([7,0],[7,1])
      game.play([0,0],[0,1])
      game.play([7,1],[7,0])
      game.play([0,1],[0,0])
      expect(game.instance_variable_get('@game_status')).to eql(0)
      
    end

    it 'when king cannot move but not in check, stalemate' do
      
    end
  end

  context 'when saving or loading,' do
    it 'a game can be saved and loaded' do
      gameA = Chess.new
      gameA.play([6,1],[4,1])
      gameA.save
      gameB = Chess.new
      gameB = gameB.load
      expect(gameB.read_board([4,1])).to eql(1)
    end
  end

end