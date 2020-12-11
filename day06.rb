# How many total unique questions in every group?
puts "Part 1"
lines = File.readlines('data06.txt').map(&:chomp)
lines << ""

group = Hash.new { |h, k| h[k] = 0 }
groups = []
lines.each do |line|
  if line.empty?
    groups << group
    group = Hash.new { |h, k| h[k] = 0 }
  else
    line.each_char { |c| group[c] += 1 }
  end
end

puts groups.map(&:keys).map(&:count).sum

puts "Part 2"

group = Hash.new { |h, k| h[k] = 0 }
group_size = 0
running_total = 0
lines.each do |line|
  if line.empty?
    everyone_answered_yes = group.values.count { |v| v == group_size }
    running_total += everyone_answered_yes
    group = Hash.new { |h, k| h[k] = 0 }
    group_size = 0
  else
    line.each_char { |c| group[c] += 1 }
    group_size += 1
  end
end

puts running_total
