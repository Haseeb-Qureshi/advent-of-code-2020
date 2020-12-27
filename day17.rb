puts 'Day 17'

INACTIVE = '.'
ACTIVE = '#'

INPUT = File.readlines('data17.txt').map(&:chomp).map(&:chars)
# INPUT = '.#.
# ..#
# ##'.lines.map(&:chomp).map(&:chars)
DIFFS = ([0, 1, -1] * 3).combination(3).uniq - [[0, 0, 0]]

def deep_dup(cube)
  cube.map { |l| l.map { |a| a.dup } }
end

def valid?(cube, i, j, k)
  i.between?(0, cube.length - 1) &&
    j.between?(0, cube[0].length - 1) &&
    k.between?(0, cube[0][0].length - 1)
end

def neighbors(cube, i, j, k)
  DIFFS.map { |di, dj, dk| [i + di, j + dj, k + dk] }
       .select { |ii, jj, kk| valid?(cube, ii, jj, kk) }
end

def active_neighbors(cube, i, j, k)
  neighbors(cube, i, j, k).count { |(i, j, k)| cube[i][j][k] == ACTIVE }
end

def rule1?(cube, i, j, k)
  cube[i][j][k] == ACTIVE && !active_neighbors(cube, i, j, k).between?(2, 3)
end

def rule2?(cube, i, j, k)
  cube[i][j][k] == INACTIVE && active_neighbors(cube, i, j, k) == 3
end

def flip(cube, i, j, k)
  cube[i][j][k] = cube[i][j][k] == ACTIVE ? INACTIVE : ACTIVE
end

def show(cube)
  puts cube.map { |g| g.map { |l| l.join }.join("\n") }.join("\n\n")
end

def simulate_cube(n)
  pad_i = (n + 1) * 2
  pad_j = (INPUT.length + 1) * 3
  pad_k = (INPUT[0].length + 1) * 3

  cube = Array.new(pad_i) { Array.new(pad_j) { Array.new(3 + pad_k) { INACTIVE } } }
  INPUT.each_index do |i|
    INPUT[i].each_index do |j|
      cube[n][pad_j / 2 + i][pad_k / 2 + j] = INPUT[i][j]
    end
  end

  n.times do
    old_cube = deep_dup(cube)

    cube.each_index do |i|
      cube[0].each_index do |j|
        cube[0][0].each_index do |k|
          if rule1?(old_cube, i, j, k)
            flip(cube, i, j, k)
          elsif rule2?(old_cube, i, j, k)
            flip(cube, i, j, k)
          end
        end
      end
    end
  end

  cube.join.count(ACTIVE)
end

puts simulate_cube(6)
