require 'set'

puts 'Part 1'

names, raw_my_ticket, raw_nearby_tickets = File.read('data16.txt').split("\n\n")

ranges = names.lines.map do |line|
  key, suffix = line.split(':')
  val = line.split(':').last.split(' or ').map do |range|
    start, fin = range.split('-').map(&:to_i)
    (start..fin)
  end
  [key, val]
end.to_h

my_ticket = raw_my_ticket.lines.last.split(',').map(&:to_i)
nearby_tickets = raw_nearby_tickets.lines.map { |l| l.split(',').map(&:to_i) }

invalid_values = nearby_tickets.each_with_object([]) do |ticket, invalids|
  ticket.each_with_index do |val, i|
    invalids << val if ranges.values.flatten.none? { |r| r.cover?(val) }
  end
end

puts invalid_values.sum

puts 'Part 2'

valid_tickets = nearby_tickets.reject do |ticket|
  ticket.any? { |val| ranges.values.flatten.none? { |r| r.cover?(val) } }
end

def match?(field, val)
  field.any? { |r| r.cover?(val) }
end

def all_match?(field, vals)
  vals.all? { |val| match?(field, val) }
end

def permute(arr1, arr2)
  arr2.map { |idx| arr1[idx] }
end
#
# def unpermute(arr1, arr2)
#   arr2.each_with_object([]).with_index do |(idx, res), i|
#     res[idx] = arr1[arr2.index(idx)]
#   end
# end

def sat(my_ticket, fields, tix)
  cols = tix[0].length.times.map { |i| tix.map { |t| t[i] } } # each column

  # generate constraints

  constraints = cols.map.with_index do |col, i|
    [i, fields.select { |name, field| all_match?(field, col) }.map(&:first)]
  end

  by_constrained = constraints.sort_by { |i, consts| consts.length }.map(&:first)
  permuted_cols = permute(cols, by_constrained)
  permuted_constraints = permuted_cols.map.with_index do |col, i|
    [i, fields.select { |name, field| all_match?(field, col) }.map(&:first)]
  end

  assignments = satisfy(fields, permuted_cols, permuted_constraints.map(&:last))

  res = []
  by_constrained.each { |idx| res[idx] = assignments[by_constrained.index(idx)] }

  my_ticket.each_with_index.reduce(1) do |acc, (el, i)|
    res[i].start_with?('departure') ? acc * el : acc
  end
end

def satisfy(fields, cols, constraints, ass = [])
  # prior assignment is correct
  # base case
  return ass if ass.length == fields.length
  # we have more fields to assign; try assigning the next constraint
  depth = ass.length

  constraints[depth].each do |field_name|
    next if ass.include?(field_name)

    if all_match?(fields[field_name], cols[depth])
      # this assignment fits
      res = satisfy(fields, cols, constraints, ass << field_name)
      return res if res
      ass.pop
    end
  end

  # we failed
  nil
end

def vals_match?(vals, field)
  vals.all? { |val| match?(field, val) }
end

puts sat(my_ticket, ranges, valid_tickets)
