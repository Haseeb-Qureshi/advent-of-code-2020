puts 'Part 1'

actions = File.readlines('data12.txt').map(&:chomp)
DIRS = [[0, 1], [-1, 0], [0, -1], [1, 0]]
      # right    down      left      up

north = 0
east = 0
vector = [0, 1]
    # north, east

actions.each do |action|
  dist = action[1..-1].to_i
  case action[0]
  when 'F'
    north, east = vector[0] * dist + north, vector[1] * dist + east
  when 'N'
    north += dist
  when 'E'
    east += dist
  when 'S'
    north -= dist
  when 'W'
    east -= dist
  when 'L', 'R'
    amount = case dist
    when 90 then 1
    when 180 then 2
    when 270 then 3
    end
    rotation = DIRS.index(vector) + (action[0] == 'L' ? -amount : amount)
    vector = DIRS.rotate(rotation).first
  else
    raise "wtf is #{action}?"
  end
end

puts north.abs + east.abs

puts 'Part 2'

north = 0
east = 0
waypoint = [1, 10]
    # north, east

actions.each do |action|
  dist = action[1..-1].to_i
  case action[0]
  when 'F'
    north, east = waypoint[0] * dist + north, waypoint[1] * dist + east
  when 'N'
    waypoint[0] += dist
  when 'E'
    waypoint[1] += dist
  when 'S'
    waypoint[0] -= dist
  when 'W'
    waypoint[1] -= dist
  when 'L', 'R'
    amount = case dist
    when 90 then 1
    when 180 then 2
    when 270 then 3
    end
    amount.times do
      waypoint.rotate!
      action[0] == 'L' ? waypoint[1] *= -1 : waypoint[0] *= -1
    end
  else
    raise "wtf is #{action}?"
  end
end

puts north.abs + east.abs
