puts 'Part 1'

lines = File.readlines('data14.txt').map(&:chomp)
mem = Hash.new(0)
mask = ''
MAX_INT = 2 ** 36 - 1

def apply_mask(value, mask)
  reversed = mask.reverse
  reversed.length.times do |i|
    case reversed[i]
    when '0'
      value &= MAX_INT - 2 ** i
    when '1'
      value |= 2 ** i
    when 'X' then next
    end
  end
  value
end

lines.each do |line|
  dest, value = line.split(' = ')
  if dest == 'mask'
    mask = value
  else
    addr = dest.match(/(\d+)/)[0].to_i
    mem[addr] = apply_mask(value.to_i, mask)
  end
end

puts mem.values.sum

puts 'Part 2'

def process_instruction!(addr, mask, mem, value)
  reversed = mask.reverse
  reversed.length.times do |i|
    addr |= 2 ** i if reversed[i] == '1'
  end

  process_mask!(addr, mask, mem, value)
end

def process_mask!(addr, mask, mem, value)
  if mask.length == 0
    mem[addr] = value
    return
  end

  mask_digit = 2 ** (mask.length - 1)

  if mask[0] == 'X'
    process_mask!(addr & (MAX_INT - mask_digit), mask[1..-1], mem, value)
    process_mask!(addr | mask_digit, mask[1..-1], mem, value)
  end
  process_mask!(addr, mask[1..-1], mem, value)
end

mem = Hash.new(0)
mask = ''

lines.each do |line|
  dest, value = line.split(' = ')
  if dest == 'mask'
    mask = value
  else
    addr = dest.match(/(\d+)/)[0].to_i
    process_instruction!(addr, mask, mem, value.to_i)
  end
end

puts mem.values.sum
