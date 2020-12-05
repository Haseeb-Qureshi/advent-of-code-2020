puts 'Part 1'
TREE = '#'
ROWS = File.readlines('data03.txt').map(&:chomp)

def count_trees(right, down)
  i = -right
  ROWS.each_with_index.count do |row, j|
    next unless j % down == 0
    i += right
    row[i % row.length] == TREE
  end
end

puts count_trees(3, 1)

puts 'Part 2'
pairs = '1,1 3,1 5,1 7,1 1,2'.split.map { |pair| pair.split(',').map(&:to_i) }
puts pairs.map { |right, down| count_trees(right, down) }.reduce(:*)
