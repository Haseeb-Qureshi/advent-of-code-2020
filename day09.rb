puts 'Part 1'

nums = File.readlines('data09.txt').map(&:chomp).map(&:to_i)

def find_invalid_number(nums)
  nums.each_cons(26) do |nums|
    if !nums[0...25].combination(2).any? { |a, b| a + b == nums[25] }
      return nums[25]
    end
  end
end

invalid_num = find_invalid_number(nums)

puts invalid_num

puts 'Part 2'

def find_contiguous_range_that_sums(nums, target)
  i, j = 0, 1
  sum = nums[i..j].sum
  loop do
    if sum < target
      j += 1
      sum += nums[j]
    elsif sum > target
      i += 1
      sum -= nums[i - 1]
    else
      return [i, j]
    end
  end
end

i, j = find_contiguous_range_that_sums(nums, invalid_num)
puts nums[i..j].sort.last + nums[i..j].sort.first
