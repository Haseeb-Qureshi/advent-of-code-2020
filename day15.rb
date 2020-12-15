INPUT = '1,20,8,12,0,14'

puts 'Part 1'

sequence = INPUT.split(',').map(&:to_i)
last_seen = Hash.new { |h, k| h[k] = [] }

0.upto(2019) do |i|
  if sequence[i]
    last_seen[sequence[i]] << i
    next
  end

  if last_seen[sequence.last].length == 1
    sequence << 0
    last_seen[0] << i
  else
    diff = last_seen[sequence.last].last(2).reduce(:-).abs
    sequence << diff
    last_seen[diff] << i
  end
end

puts sequence.last

puts 'Part 2'
