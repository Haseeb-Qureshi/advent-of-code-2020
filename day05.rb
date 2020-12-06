#FBFBBFFRLR

puts "Part 1"

def binary_search(lo, hi, down_sign, up_sign, instructions)
  instructions.each_char do |inst|
    if inst == down_sign
      hi = (hi - lo) / 2 + lo
    elsif inst == up_sign
      lo = (hi + lo) / 2 + 1
    end
  end

  raise StandardError.new("#{[instructions, lo, hi]}") unless hi == lo
  hi
end

def row_and_col(instructions)
  row = binary_search(0, 127, 'F', 'B', instructions[0..6])
  col = binary_search(0, 7, 'L', 'R', instructions[7..-1])
  [row, col]
end

def seat_id(instructions)
  row, col = row_and_col(instructions)
  row * 8 + col
end

passes = File.readlines("data05.txt").map(&:chomp)
puts passes.map { |pass| seat_id(pass) }.max

puts "Part 2"
open_seats = 0.upto(passes.length).to_a - passes.map { |pass| seat_id(pass) }
puts open_seats.each_cons(2).find { |a, b| b - a != 1 }[1]
