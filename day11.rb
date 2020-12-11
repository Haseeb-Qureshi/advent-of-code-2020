require 'set'
puts 'Part 1'

EMPTY = 'L'
TAKEN = '#'
FLOOR = '.'
DELTAS = ([0, 1, -1] * 2).combination(2).uniq.reject { |a, b| a == 0 && b == 0 }

grid = File.readlines('data11.txt').map(&:chomp).map(&:chars)

def hash(grid)
  sum = 0
  place = 0
  grid.length.times do |i|
    grid[0].length.times do |j|
      place += 1
      digit = case grid[i][j]
      when EMPTY then 0
      when TAKEN then 1
      when FLOOR then 2
      end
      sum += (place) ** 3 * digit
    end
  end
  sum
end

def valid?(i, j, grid)
  i.between?(0, grid.length - 1) && j.between?(0, grid[0].length - 1)
end

def adjacents(i, j, grid)
  DELTAS.map { |dx, dy| [i + dx, j + dy]}
        .select { |i, j| valid?(i, j, grid) }
end

def neighbors(i, j, grid)
  adjacents(i, j, grid).map { |i, j| grid[i][j] }
end

previous_hashes = Set.new([hash(grid)])
new_grid = Array.new(grid.length) { Array.new(grid[0].length) { 0 } }

loop do
  new_grid.each_index do |i|
    new_grid[0].each_index do |j|
      if grid[i][j] == FLOOR
        new_grid[i][j] = FLOOR
      elsif grid[i][j] == EMPTY && neighbors(i, j, grid).count(TAKEN) == 0
        new_grid[i][j] = TAKEN
      elsif grid[i][j] == TAKEN && neighbors(i, j, grid).count(TAKEN) >= 4
        new_grid[i][j] = EMPTY
      else
        new_grid[i][j] = grid[i][j]
      end
    end
  end

  hash = hash(new_grid)
  break if previous_hashes.include?(hash)
  previous_hashes << hash
  grid, new_grid = new_grid, grid
end

puts new_grid.flatten.count(TAKEN)

puts 'Part 2'

def seen_seats(i, j, grid)
  # 
end
