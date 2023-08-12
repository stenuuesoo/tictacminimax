class TicTacToe
  attr_accessor :board, :current_player

  def initialize
    @board = Array.new(3) { Array.new(3, nil) }
    @current_player = 'X'
  end

  def display_board
    @board.each do |row|
      puts row.map { |cell| cell.nil? ? '.' : cell }.join(" | ")
      puts "-" * 9 unless @board.last == row
    end
    puts
  end

  def play_move
    move = available_moves.sample
    make_move(move, current_player)
    display_board
    toggle_current_player
    move
  end

  def available_moves
    moves = []
    3.times do |i|
      3.times do |j|
        moves << [i, j] if board[i][j].nil?
      end
    end
    moves
  end

  def make_move(move, player)
    x, y = move
    @board[x][y] = player
  end

  def toggle_current_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def game_over?
    win_conditions.any? { |condition| condition.all? { |x, y| board[x][y] == 'X' } } ||
      win_conditions.any? { |condition| condition.all? { |x, y| board[x][y] == 'O' } } ||
      available_moves.empty?
  end

  def winner
    return 'X' if win_conditions.any? { |condition| condition.all? { |x, y| board[x][y] == 'X' } }
    return 'O' if win_conditions.any? { |condition| condition.all? { |x, y| board[x][y] == 'O' } }
    nil
  end

  def win_conditions
    [
      # Rows
      [[0, 0], [0, 1], [0, 2]],
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      # Columns
      [[0, 0], [1, 0], [2, 0]],
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]],
      # Diagonals
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]]
    ]
  end
end

game = TicTacToe.new

puts "Starting Tic Tac Toe game!"
game.display_board

move_history = []

until game.game_over?
  move = game.play_move
  move_history << "#{game.current_player} played at position #{move[0] + 1},#{move[1] + 1}"
end

puts "Game Summary:"
move_history.each { |history| puts history }

if game.winner
  puts "#{game.winner} won the game!"
else
  puts "It's a draw!"
end
