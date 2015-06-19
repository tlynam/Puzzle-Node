require 'pry'

class WordMatch
  attr_reader :matches

  def initialize(search, *words)
    @search = search
    @words = words
    @matches = {}
  end

  def generate_combinations word
    chars = word.chars
    chars.size.times.flat_map do |idx|
      chars.combination(idx + 1).to_a
    end.uniq
  end

  def generate_matches
    search_combinations = generate_combinations @search

    @words.each do |word|
      combinations = generate_combinations word
      @matches[word] = combinations & search_combinations
    end
  end

  def result
    @matches.max_by{ |word, matches| matches.max_by(&:size).size }.first
  end

end

wm = WordMatch.new("inndietlly","immediately","incidentally")
wm.generate_matches
puts wm.result
binding.pry
