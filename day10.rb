require 'set'
puts 'Part 1'

voltages = File.readlines('data10.txt').map(&:to_i).sort!
voltages.unshift(0)
voltages << voltages.last + 3
puts voltages.each_cons(2)
             .map { |a, b| b - a }
             .group_by { |x| x }
             .values
             .map(&:length)
             .reduce(:*)

puts 'Part 2'

all_voltages = Set.new(voltages)
sequence = (voltages.first..voltages.last).to_a
sequence.each_index { |i| sequence[i] = all_voltages.include?(i) }
ways_to_finish = [1]
ways_to_finish << (sequence[1] ? 1 : 0)
ways_to_finish << (sequence[2] ? ways_to_finish[1] + 1 : 0)
(3...sequence.length).each do |i|
  if !sequence[i]
    ways_to_finish << 0
  else
    ways_to_finish << ways_to_finish.last(3).sum
  end
end

puts ways_to_finish.last
