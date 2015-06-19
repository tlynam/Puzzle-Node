require 'nori'
require 'pry'
require 'smarter_csv'

parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
file = File.open("SAMPLE_RATES.xml")
xml = file.read
rates = parser.parse(xml)

usd_rates = {}
while rates[:rates][:rate].size > 0 do
  rates[:rates][:rate].each_with_index do |rate,index|
    if rate[:from] == "USD"
      rates[:rates][:rate].delete_at(index)
      next
    end
    if rate[:to] == "USD"
      usd_rates[rate[:from]] = BigDecimal.new(rate[:conversion])
      rates[:rates][:rate].delete_at(index)
      next
    end
    if usd_rates[rate[:to]]
      usd_rates[rate[:from]] = BigDecimal.new(rate[:conversion]) * BigDecimal.new(usd_rates[rate[:to]])
      rates[:rates][:rate].delete_at(index)
      next
    end
  end
end

# find AUD-USD
# #with AUD-BIT, AUD-CAD, CAD-USD
class Conversions
  @conversions = {}
  def self.set(from, to, rate)
    @conversions[[from, to]] = BigDecimal.new rate
  end

  def self.find(from, to)
    if rate = @conversions[[from, to]]
      rate
    elsif inverse_rate = @conversions[[to, from]]
      1 / inverse_rate
    else
      initial = @conversions.keys.find{ |f, t| f == from } or return
      second  = find(initial[1], to) or return
      @conversions[initial] * second
    end
  end
end

# puts rates[:rates][:rate]
# puts usd_rates

total = BigDecimal.new(0)
trns = SmarterCSV.process('SAMPLE_TRANS.csv')
trns.each do |trn|
  if trn[:sku] == "DM1182"
    amount = BigDecimal(trn[:amount].match(/[0-9\.]+/).to_s)
    country = trn[:amount].match(/[A-Z]+/)

    if country.to_s == "USD"
      total += amount
    else
      total += amount * usd_rates[country.to_s]
    end
  end
end

puts total.to_f
