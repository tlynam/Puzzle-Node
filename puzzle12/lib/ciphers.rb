require 'pry'

class CaesarCipher
  def initialize(input, word_list = "word_list.txt")
    @alphabet = ("A".."Z").to_a
    @input_chars = input.chars
    @dictionary = File.read(word_list).split("\n")
  end

  def candidates
    @candidates ||= find_candidates
  end

  private

  def find_candidates
    candidates = []
    chars = @input_chars
    25.times do
      candidates << chars.join if @dictionary.include?(chars.join.downcase)
      chars = chars.map{|letter| next_letter letter}
    end
    candidates
  end

  def next_letter(letter)
    if letter == "Z"
      "A"
    else
      letter.succ
    end
  end

end

class VigenereCipher
  def initialize(key)
    @alphabet = ("A".."Z").to_a
    @key = key
    @encrypted_message = File.open("simple_cipher.txt").read.split("\n\n")[1]
  end

  def decrypted_message
    @decrypted_message ||= decrypt_message
  end

  private

  def decrypt_message
    key_place, decrypted_message = 0, ""
    @encrypted_message.each_char do |char|
      if char =~ /[A-Z]/
        decrypted_message << decrypt_letter(@key[key_place], char)
        if key_place == (@key.size - 1)
          key_place = 0
        else
          key_place += 1
        end
      else
        decrypted_message << char
      end
    end
    decrypted_message
  end

  def decrypt_letter(key_letter, message_letter)
    key_location = @alphabet.find_index(key_letter)
    msg_location = @alphabet.find_index(message_letter)
    @alphabet[msg_location - key_location]
  end

end

c = CaesarCipher.new("zrffntr".upcase!)
key = c.candidates
puts key
# v = VigenereCipher.new(key)
# puts v.decrypted_message
# binding.pry

