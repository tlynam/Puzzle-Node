class Rot13
  def initialize(input_str)
    @input_str = input_str
  end

  def decrypted_message
    @decrypted_message ||= decode
  end

  private

  def decode
    decrypted_message = ""
    @input_str.each_char do |char|
      if char =~ /\w/
        13.times do
          char = next_letter char
        end
      end
      decrypted_message << char
    end
    decrypted_message
  end

  def next_letter(letter)
    if letter == "Z"
      "A"
    elsif letter == "z"
      "a"
    else
      letter.succ
    end
  end

end

message = Rot13.new("Fraq hf gur pbqr lbh hfrq gb qrpbqr guvf zrffntr")
puts message.decrypted_message
