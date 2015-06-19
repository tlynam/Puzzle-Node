require 'pry'

class ChessValidator
  attr_reader :board

  def initialize(file)
    # @pieces = pieces
    # @moves = moves
    @board = import_piece_positions(file)
  end

  def create_board
    board = {}
    number = 1
    ("a".."h").each do |letter|
      board[[letter, number]] = "-"
      (1..8).each do |number|
        board[[letter, number]] = "-"
        number += 1
      end
      letter = letter.succ
    end
    board
  end

  def import_piece_positions file
    board = {}
    contents = File.open(file).read
    row = 8
    letters = ("a".."h").to_a
    letter = 0
    contents.split("\n").each do |line|
      line.split.each do |piece|
        letter = 0 if letter == 8
        board[[letters[letter], row]] = piece
        letter += 1
      end
      row -= 1
    end
    board
  end

  def legal_move(start_position, end_position)
    start_column, start_row = start_position[0], start_position[1]
    end_column, end_row = end_position[0], end_position[1]

    start_color, start_piece = @board[[start_column, start_row]][0],
      @board[[start_column, start_row]][1]

    end_color, end_piece = @board[[start_column, start_row]][0],
      @board[[start_column, start_row]][1]

    return "ILLEGAL" if @board[[end_column, end_row]] != "--" && start_color == end_color

    case piece
    when "P" #pawn
      if color == "w"
        if start_row == 2
          return "LEGAL" if end_row == 3 || end_row == 4
        elsif #when capturing

        elsif #other movements

        else
          return "ILLEGAL"
      else #color is b
        if start_row == 7
          return "LEGAL" if end_row == 6 || end_row == 5
        elsif

        else
          return "ILLEGAL"
      end
    when "R" #rook

    when "N" #knight

    when "B" #bishop

    when "Q" #queen

    when "K" #king

    else
      raise "#{piece.inspect} is an invalid piece"
    end
  end

end

chessmoves = ChessValidator.new("simple_board.txt")
# binding.pry
# chessmoves.import_piece_positions
puts chessmoves.inspect
