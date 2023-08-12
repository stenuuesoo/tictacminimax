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

  def undo_move(move)
    x, y = move
    @board[x][y] = nil
  end

  def toggle_current_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def game_over?
    winner || available_moves.empty?
  end

  def winner
    win_conditions.each do |condition|
      if condition.all? { |x, y| board[x][y] == 'X' }
        return 'X'
      elsif condition.all? { |x, y| board[x][y] == 'O' }
        return 'O'
      end
    end
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

  def minimax(player)
    return 10 if winner == 'X'
    return -10 if winner == 'O'
    return 0 if available_moves.empty?

    moves = available_moves
    scores = []

    moves.each do |move|
      make_move(move, player)
      if player == 'X'
        scores << minimax('O')
      else
        scores << minimax('X')
      end
      undo_move(move)
    end

    player == 'X' ? scores.max : scores.min
  end

  def best_move_for_player(player)
    best_score = player == 'X' ? -Float::INFINITY : Float::INFINITY
    chosen_move = nil

    available_moves.each do |move|
      make_move(move, player)
      move_score = minimax(player == 'X' ? 'O' : 'X')
      if player == 'X' && move_score > best_score || player == 'O' && move_score < best_score
        best_score = move_score
        chosen_move = move
      end
      undo_move(move)
    end

    chosen_move
  end

  def play_move
    move = best_move_for_player(current_player)
    make_move(move, current_player)
    display_board
    toggle_current_player
  end

  def random_first_move
    move = available_moves.sample
    make_move(move, 'X')
    toggle_current_player
  end
end

# Function to play one game and return the winner
def play_one_game(game)
  game.random_first_move
  game.display_board
  until game.game_over?
    game.play_move
  end
  game.winner
end

# Counter for results
x_wins = 0
o_wins = 0
draws = 0

# For storing the final boards
final_boards = []

# Play 10 games
10.times do |i|
  game = TicTacToe.new
  puts "Starting game #{i + 1}"
  winner = play_one_game(game)

  final_boards << game.board # Store the final board

  if winner == 'X'
    x_wins += 1
    puts "Result of game #{i + 1}: X won!"
  elsif winner == 'O'
    o_wins += 1
    puts "Result of game #{i + 1}: O won!"
  else
    draws += 1
    puts "Result of game #{i + 1}: It's a draw!"
  end
  puts "\n\n"
end

# Display the final boards side by side
puts "Final Boards after 10 games:\n\n"
3.times do |row|
  final_boards.each do |board|
    print board[row].map { |cell| cell.nil? ? '.' : cell }.join(" | ")
    print "     "
  end
  puts "\n" + ("-" * 9 + "     ") * 10 + "\n" unless row == 2
end

# Display the final results
puts "\nFinal Results after 10 games:"
puts "X wins: #{x_wins}"
puts "O wins: #{o_wins}"
puts "Draws: #{draws}"
