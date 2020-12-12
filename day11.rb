require 'set'
puts 'Part 1'

EMPTY = 'L'
TAKEN = '#'
FLOOR = '.'
DELTAS = ([0, 1, -1] * 2).combination(2).uniq.reject { |a, b| a == 0 && b == 0 }

def process_game_of_life(rule1, rule2)
  grid = File.readlines('data11.txt').map(&:chomp).map(&:chars)
  previous_hashes = Set.new([hash(grid)])
  new_grid = Array.new(grid.length) { Array.new(grid[0].length) { 0 } }

  loop do
    new_grid.each_index do |i|
      new_grid[0].each_index do |j|
        if grid[i][j] == FLOOR
          new_grid[i][j] = FLOOR
        elsif rule1.call(i, j, grid)
          new_grid[i][j] = TAKEN
        elsif rule2.call(i, j, grid)
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

  new_grid.flatten.count(TAKEN)
end

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

def empty_rule?(i, j, grid)
  grid[i][j] == EMPTY && neighbors(i, j, grid).count(TAKEN) == 0
end

def taken_rule?(i, j, grid)
  grid[i][j] == TAKEN && neighbors(i, j, grid).count(TAKEN) >= 4
end

puts process_game_of_life(method(:empty_rule?), method(:taken_rule?))

puts 'Part 2'

def occupied_visible_seats(i, j, grid)
  occupied = 0
  orig = [i, j]

  down = [->() { i < grid.length }, ->() { i += 1 }]
  left = [->() { j >= 0 }, ->() { j -= 1 }]
  up = [->() { i >= 0 }, ->() { i -= 1 }]
  right = [->() { j < grid[0].length }, ->() { j += 1 }]
  down_right = [->() { i < grid.length && j < grid[0].length }, ->() { j += 1; i += 1 }]
  down_left = [->() { i < grid.length && j >= 0 }, ->() { j -= 1; i += 1 }]
  up_left = [->() { i >= 0 && j >= 0 }, ->() { j -= 1; i -= 1 }]
  up_right = [->() { i >= 0 && j < grid[0].length }, ->() { j += 1; i -= 1 }]

  [down, left, up, right, down_right, down_left, up_left, up_right].each do |cond, increment|
    loop do
      increment.call
      break unless cond.call
      next if grid[i][j] == FLOOR
      break if grid[i][j] == EMPTY
      occupied += 1
      break
    end
    i, j = orig
  end
  occupied
end

def empty_rule_visible?(i, j, grid)
  return false unless grid[i][j] == EMPTY
  occupied_visible_seats(i, j, grid) == 0
end

def taken_rule_visible?(i, j, grid)
  return false unless grid[i][j] == TAKEN
  occupied_visible_seats(i, j, grid) >= 5
end

puts process_game_of_life(method(:empty_rule_visible?), method(:taken_rule_visible?))
