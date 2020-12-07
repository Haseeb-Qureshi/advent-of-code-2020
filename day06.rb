puts 'Part 1'

lines = File.readlines('data06.txt').map(&:chomp)

bags = {}
lines.each do |line|
  bag_color, rest = line.split(' bags contain ')
  rest.chop.split(',').map do |chunk|
    num, desc1, desc2, _ = chunk.split
    (bags[bag_color] ||= []) << [num.to_i, "#{desc1} #{desc2}"]
  end
end

def can_dfs?(color, bags, can_reach)
  return can_reach[color] if can_reach.has_key?(color)
  return false if bags[color][0][0] == 0
  can_reach[color] = bags[color].map(&:last).any? do |c|
    if c == TARGET
      can_reach[color] = true
      return true
    else
      can_dfs?(c, bags, can_reach)
    end
  end
end

TARGET = 'shiny gold'
can_reach = {}
reachable_bags = bags.keys.count do |k|
  next if k == TARGET
  can_dfs?(k, bags, can_reach)
end

puts reachable_bags

puts "Part 2"

def count_bags_in(color, bags, memo = {})
  return memo[color] if memo[color]
  return 0 if bags[color][0][0] == 0
  memo[color] = bags[color].sum do |n, new_color|
    n * (1 + count_bags_in(new_color, bags, memo))
  end
end

puts count_bags_in(TARGET, bags)
