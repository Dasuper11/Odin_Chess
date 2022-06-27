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
  
end