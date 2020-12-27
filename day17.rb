require 'set'

puts 'Day 17'

INACTIVE = '.'
ACTIVE = '#'

INPUT = File.readlines('data17.txt').map(&:chomp).map(&:chars)
DIFFS_3D = ([0, 1, -1] * 3).combination(3).uniq - [[0, 0, 0]]

def deep_dup(cube)
  new_cube = Hash.new { |h, k| h[k] = Hash.new {|h, k| h[k] = Hash.new(INACTIVE) } }

  cube.each_key do |i|
    cube[i].each_key do |j|
      cube[i][j].each_key do |k|
        new_cube[i][j][k] = cube[i][j][k].dup
      end
    end
  end
  new_cube
end

def neighbors(cube, i, j, k)
  DIFFS_3D.map { |di, dj, dk| [i + di, j + dj, k + dk] }
end

def active_neighbors(cube, i, j, k)
  neighbors(cube, i, j, k).count do |(i, j, k)|
    cube[i][j][k] == ACTIVE
  end
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
  cube.keys.minmax.reduce(&:upto).each do |i|
    cube.values.map(&:keys).flatten.minmax.reduce(&:upto).each do |j|
      cube.values.map(&:values).flatten.map(&:keys).flatten.minmax.reduce(&:upto).each do |k|
        print cube[i][j][k]
      end
      puts
    end
    puts
  end
end

def simulate_cube(n)
  cube = Hash.new { |h, k| h[k] = Hash.new {|h, k| h[k] = Hash.new(INACTIVE) } }

  INPUT.each_index do |i|
    INPUT[i].each_index do |j|
      cube[0][i][j] = INPUT[i][j]
    end
  end

  n.times do
    old_cube = deep_dup(cube)

    all_to_consider = Set.new

    cube.each_key do |i|
      cube[i].each_key do |j|
        cube[i][j].each_key do |k|
          all_to_consider << [i, j, k]
          neighbors(old_cube, i, j, k).each { |coords| all_to_consider << coords }
        end
      end
    end

    all_to_consider.sort.each do |i, j, k|
      if rule1?(old_cube, i, j, k)
        flip(cube, i, j, k)
      elsif rule2?(old_cube, i, j, k)
        flip(cube, i, j, k)
      end
    end
  end

  cube.to_s.count(ACTIVE)
end

puts simulate_cube(6)

puts 'Part 2'
DIFFS_4D = ([0, 1, -1] * 4).combination(4).uniq - [[0, 0, 0, 0]]

def deep_hyperdup(hcube)
  new_hcube = Hash.new do |h, k|
    h[k] = Hash.new do |h, k|
      h[k] = Hash.new do |h, k|
        h[k] = Hash.new(INACTIVE)
      end
    end
  end

  hcube.each_key do |i|
    hcube[i].each_key do |j|
      hcube[i][j].each_key do |k|
        hcube[i][j][k].each_key do |l|
          new_hcube[i][j][k][l] = hcube[i][j][k][l].dup
        end
      end
    end
  end
  new_hcube
end

def hyper_neighbors(hcube, i, j, k, l)
  DIFFS_4D.map { |di, dj, dk, dl| [i + di, j + dj, k + dk, l + dl] }
end

def active_hyper_neighbors(hcube, i, j, k, l)
  hyper_neighbors(hcube, i, j, k, l).count { |(i, j, k, l)| hcube[i][j][k][l] == ACTIVE }
end

def hyper_rule1?(hcube, i, j, k, l)
  hcube[i][j][k][l] == ACTIVE && !active_hyper_neighbors(hcube, i, j, k, l).between?(2, 3)
end

def hyper_rule2?(hcube, i, j, k, l)
  hcube[i][j][k][l] == INACTIVE && active_hyper_neighbors(hcube, i, j, k, l) == 3
end

def hyper_flip(hcube, i, j, k, l)
  hcube[i][j][k][l] = hcube[i][j][k][l] == ACTIVE ? INACTIVE : ACTIVE
end

def simulate_hcube(n)
  hcube = Hash.new do |h, k|
    h[k] = Hash.new do |h, k|
      h[k] = Hash.new do |h, k|
        h[k] = Hash.new(INACTIVE)
      end
    end
  end

  INPUT.each_index do |i|
    INPUT[i].each_index do |j|
      hcube[0][0][i][j] = INPUT[i][j]
    end
  end

  n.times do
    old_hcube = deep_hyperdup(hcube)

    all_to_consider = Set.new

    hcube.each_key do |i|
      hcube[i].each_key do |j|
        hcube[i][j].each_key do |k|
          hcube[i][j][k].each_key do |l|
            all_to_consider << [i, j, k, l]
            hyper_neighbors(old_hcube, i, j, k, l).each { |coords| all_to_consider << coords }
          end
        end
      end
    end

    all_to_consider.sort.each do |i, j, k, l|
      if hyper_rule1?(old_hcube, i, j, k, l)
        hyper_flip(hcube, i, j, k, l)
      elsif hyper_rule2?(old_hcube, i, j, k, l)
        hyper_flip(hcube, i, j, k, l)
      end
    end
  end

  hcube.to_s.count(ACTIVE)
end

puts simulate_hcube(6)
