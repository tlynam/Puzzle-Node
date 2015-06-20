require 'rspec'
require '../lib/ciphers'

RSpec.describe CaesarCipher do
  before do
    @caesar_cipher = CaesarCipher.new("UREXVIFLJ")
  end

  describe '#next_letter' do
    it "returns the next letter in alphabet" do
      expect(@caesar_cipher.send(:next_letter, "Z")).to eq("A")
      expect(@caesar_cipher.send(:next_letter, "A")).to eq("B")
      expect(@caesar_cipher.send(:next_letter, "D")).to eq("E")
    end
  end

  describe '#find_candidates' do
    it 'returns potential cipher key candidates' do
      @caesar_cipher2 = CaesarCipher.new("RLCOPY")

      expect(@caesar_cipher.candidates).to eq(["DANGEROUS"])
      expect(@caesar_cipher2.candidates).to eq(["GARDEN"])
    end
  end
end

RSpec.describe VigenereCipher do

  DECRYPTED_MESSAGE = "COWARDS DIE MANY TIMES BEFORE THEIR DEATHS; THE VALIANT NEVER TASTE OF DEATH BUT ONCE.\n" +
  "OF ALL THE WONDERS THAT I YET HAVE HEARD, IT SEEMS TO ME MOST STRANGE THAT MEN SHOULD FEAR;\n"+
  "SEEING THAT DEATH, A NECESSARY END, WILL COME WHEN IT WILL COME.\n"

  before do
    @vigenere_cipher = VigenereCipher.new("GARDEN")
  end

  describe '#decrypt_letter' do
    it 'returns decrypted letter when passed letter and letter offset' do
      expect(@vigenere_cipher.send(:decrypt_letter, "G", "I")).to eq("C")
    end
  end

  describe '#decrypted_message' do
    it 'returns decrypted message' do
      expect(@vigenere_cipher.decrypted_message).to eq(DECRYPTED_MESSAGE)
    end
  end
end
