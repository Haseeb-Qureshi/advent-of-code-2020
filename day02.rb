puts "Part 1"
lines = File.readlines('data02.txt').map(&:chomp)
valid_passwords = lines.count do |line|
  bounds, char, password = line.split
  min, max = bounds.split('-').map(&:to_i)
  char = char[0]
  password.count(char).between?(min, max)
end

puts valid_passwords

puts "Part 2"
new_valid_passwords = lines.count do |line|
  positions, char, password = line.split
  i, j = positions.split('-').map(&:to_i)
  char = char[0]
  [password[i - 1] == char, password[j - 1] == char].count(true) == 1
end

puts new_valid_passwords
