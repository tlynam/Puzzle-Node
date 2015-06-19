require 'pry'
require 'time'
require 'set'
require 'forwardable'

class Flight
  attr_reader :departure_location, :arrival_location,
              :departure_time, :arrival_time, :cost
  def initialize(string)
    /(?<d_loc>\w) (?<a_loc>\w) (?<d_time>[0-9:]+) (?<a_time>[0-9:]+) (?<cost>[0-9.]+)/ =~ string
    @departure_location, @arrival_location, @departure_time, @arrival_time, @cost =
    d_loc, a_loc, Time.parse(d_time), Time.parse(a_time), Float(cost)
  end

  def inspect
    "<Flight #{@departure_location} -> #{@arrival_location}" +
    " #{@departure_time.strftime("%k:%M")} (#{duration.to_i/60} minutes)>"
  end

  def duration
    @arrival_time - @departure_time
  end
end

class Route
  attr_reader :flights

  def initialize(flights)
    @flights = flights
  end

  def cost
    @flights.map(&:cost).reduce :+
  end

  def duration
    @flights.last.arrival_time - @flights.first.departure_time
  end

  def path
    @flights.flat_map{ |f| [f.departure_location, f.arrival_location] }.uniq
  end

  def to_s
    "<Route #{path.join(' -> ')} " +
    "Cost: #{cost} Duration: #{duration.to_i/60} minutes>"
  end

  include Comparable
  def <=>(other)
    flights <=> other.flights
  end

  alias eql? ==

  extend Forwardable

  def_delegator :@flights, :hash

  def hash
    @flights.hash
  end

end

class Schedule
  attr_reader :origin, :destination, :routes, :flights

  DEFAULT_FLIGHTS = [
    "A B 08:00 09:00 50.00","A B 12:00 13:00 300.00","A C 14:00 15:30 175.00",
    "B C 10:00 11:00 75.00","B Z 15:00 16:30 250.00","C Z 16:00 19:00 100.00",
    "C B 15:45 16:45 50.00"]

  def initialize(origin, destination, flights = DEFAULT_FLIGHTS)
    @origin, @destination = origin, destination
    @flights = flights.map{ |str| Flight.new str }.sort_by(&:arrival_location).reverse
  end

  def routes
    @routes || begin
      @routes = Set.new
      find_routes
      @routes
    end
  end

  def find_routes(origin = @origin, route = [], tries = 1)
    @flights.select { |f| f.departure_location == origin }.each do |flight|
      route = [] if origin == @origin
     if route.empty? || flight.departure_time > route.last.arrival_time
        if flight.arrival_location == @destination
          @routes << Route.new(route + [flight])
        elsif tries < 5
          find_routes(flight.arrival_location, route + [flight], tries + 1)
        end
     end
    end
  end

end

schedule = Schedule.new("A", "Z", File.read('sample-input.txt').split("\n\n").last.split("\n")[1..-1])
puts schedule.routes.inspect

puts "Steve's schedule: ", schedule.routes.sort_by{ |route| [route.cost, route.duration] }
puts "Jennifer's schedule: ", schedule.routes.sort_by{ |route| [route.duration, route.cost] }
binding.pry
