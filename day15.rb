INPUT = '1,20,8,12,0,14'

puts 'Part 1'

def nth_number(n)
  sequence = INPUT.split(',').map(&:to_i)
  last_seen = Hash.new { |h, k| h[k] = [] }

  0.upto(n - 1) do |i|
    if sequence[i] # initialize last_seen for starting sequence
      last_seen[sequence[i]] << i
      next
    end

    if last_seen[sequence.last].length == 1
      (sequence << 0).shift
      last_seen[0] << i
    else
      diff = last_seen[sequence.last].last(2).reduce(:-).abs
      (sequence << diff).shift
      last_seen[diff] << i
      last_seen[diff].shift if last_seen[diff].length > 2
    end
  end

  sequence.last
end

puts nth_number(2020)

puts 'Part 2'

puts nth_number(30000000)
