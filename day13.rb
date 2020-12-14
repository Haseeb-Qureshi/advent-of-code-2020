require 'csp-solver'
puts 'Part 1'

input = File.readlines('data13.txt').map(&:chomp)
depart_time = input[0].to_i
buses = input[1].split(',').reject { |n| n == 'x' }.map(&:to_i)

def minutes_late(bus, depart_time)
  depart_time.fdiv(bus).ceil * bus - depart_time
end

best_bus = buses.min_by { |bus| minutes_late(bus, depart_time) }
puts best_bus * minutes_late(best_bus, depart_time)

puts 'Part 2'

'7,13,x,x,59,x,31,19'
# solve system of equations
'7 * k1 = n'
'13 * k2 = n + 1'

"7k1 - 13k2 = -1"
"7k1 + 1 = 13k2"

'59 * k3 = n + 4'
'31 * k4 = n + 6'
'19 * k5 = n + 7'

'7 * a = n'
'13 * b = n + 1'
'59 * c = n + 4'
'31 * d = n + 6'
'19 * e = n + 7'


'28a - 13b - 59c - 31d - 19e = -1 - 4 - 6 - 7'
'28a - 13b - 59c - 31d - 19e = -18'


'13 * k2 - 1 = 7 * k1'
'= 7 / 13 +'


'59 * k3 = n + 4'
'31 * k4 = n + 6'
'19 * k5 = n + 7'
