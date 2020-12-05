require "set"
puts "Part 1"

nums = Set.new(File.readlines("data01.txt").map { |l| l.chomp.to_i })
first_entry = nums.find do |x|
  nums.include?(2020 - x)
end

puts first_entry * (2020 - first_entry)

puts "Part 2"

subsums = nums.to_a.combination(2).map { |x, y| [x + y, [x, y]] }.to_h
z = nums.find do |maybe_z|
  subsums.include?(2020 - maybe_z)
end
x, y = subsums[2020 - z]

puts x * y * z
