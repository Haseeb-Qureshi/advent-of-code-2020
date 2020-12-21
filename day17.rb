puts 'Day 17'

EMPTY = '.'
ACTIVE = '#'

# INPUT = File.readlines('data17.txt').map(&:chomp).map(&:chars)
INPUT = '.#.
..#
###'.lines.map(&:chomp).map(&:chars)
DIFFS = ([0, 1, -1] * 3).combination(3).uniq - [[0, 0, 0]]

def deep_dup(grid)
  grid.map { |g| g.map { |a| a.dup } }
end

def valid?(grid, x, y)
  x.between?(0, grid[0].length - 1) && y.between?(0, grid[0][0].length - 1)
end

def neighbors(grid, x, y, z)
  DIFFS.map { |dx, dy, dz| [x + dx, y + dy, z + dz] }
       .select { |xx, yy, _| valid?(grid, xx, yy) }
end

def active_neighbors(grid, x, y, z)
  neighbors(grid, x, y, z).select { |(x, y, z)| grid[x][y][z] == ACTIVE }
                          .count
end

def rule1?(grid, i, j, k)
  grid[i][j][k] == EMPTY && active_neighbors(grid, i, j, k) == 3
end

def rule2?(grid, i, j, k)
  grid[i][j][k] == ACTIVE && !active_neighbors(grid, i, j, k).between?(2, 3)
end

def show(cube)
  puts cube.map { |g| g.map { |l| l.join }.join("\n") }.join("\n\n")
end

def simulate_cube(n)
  len = INPUT.length
  cube = Array.new((n + 1) * 2) { Array.new(len) { Array.new(len) { EMPTY } } }
  cube[n] = INPUT.dup

  n.times do
    old_cube = deep_dup(cube)

    show cube

    cube.each_index do |i|
      cube[0].each_index do |j|
        cube[0][0].each_index do |k|
          if rule1?(old_cube, i, j, k)
            cube[i][j][k] = ACTIVE
          elsif rule2?(old_cube, i, j, k)
            cube[i][j][k] = EMPTY
          end
        end
      end
    end
  end

  4.times { puts }

  show cube

  cube.join.count(ACTIVE)
end

puts simulate_cube(1)
