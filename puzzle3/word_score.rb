require 'pry'

class SpellingSuggestion
  attr_accessor :input_word, :word1, :word2, :word1_score, :word2_score

  def initialize(input_word, word1, word2)
    @input_word = input_word
    @word1 = word1
    @word2 = word2
  end

  def compute_match
    input_chars1 = @input_word.chars.group_by {|l| l}
    input_chars2 = @input_word.chars.group_by {|l| l}

    word1_chars = @word1.chars.group_by {|l| l}
    word2_chars = @word2.chars.group_by {|l| l}

    input_chars1.each do |k,v|
      input_chars1[k] = v.size - word1_chars[k].size if word1_chars[k]
    end

    input_chars2.each do |k,v|
      input_chars2[k] = v.size - word2_chars[k].size if word2_chars[k]
    end

    @word1_score = calc_score input_chars1
    @word2_score = calc_score input_chars2

    if @word1_score > @word2_score
      return @word1
    elsif @word2_score > @word1_score
      return @word2
    else
      raise RuntimeError
    end
  end

  def calc_score input
    score = 0
    input.each do |k,v|
      score += 1 if v >= 0
    end
    score
  end

end

class WordScore
  attr_accessor :file_name, :number_of_groups, :word_groups, :groups

  def initialize(file_name)
    @file_name = file_name
    @word_groups = []
    @groups = []
  end

  def read_file
    File.open(@file_name) do |file|
      @number_of_groups = Integer(file.gets.strip)
      contents = file.read
      @groups = contents.split("\n")
      @groups = @groups - [""]
    end
  end

  def parse_data
    @number_of_groups.times do
      @word_groups << SpellingSuggestion.new(@groups[0], @groups[1], @groups[2])
      @groups.delete_at(0)
      @groups.delete_at(1)
      @groups.delete_at(2)
    end
  end

  def compute_matches
    puts @word_groups.map &:compute_match
  end

end

wordscore = WordScore.new("SAMPLE_INPUT.txt")
wordscore.read_file
wordscore.parse_data
wordscore.word_groups
wordscore.compute_matches
# binding.pry
