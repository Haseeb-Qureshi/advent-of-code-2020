require 'set'

puts 'Part 1'

names, raw_my_ticket, raw_nearby_tickets = File.read('data16.txt').split("\n\n")

ranges = names.lines.map do |line|
  line.split(':').last.split(' or ').map do |range|
    start, fin = range.split('-').map(&:to_i)
    (start..fin)
  end
end

my_ticket = raw_my_ticket.lines.last.split(',').map(&:to_i)
nearby_tickets = raw_nearby_tickets.lines.map { |l| l.split(',').map(&:to_i) }

invalid_values = nearby_tickets.each_with_object([]) do |ticket, invalids|
  ticket.each_with_index do |val, i|
    invalids << val if ranges.flatten.none? { |r| r.cover?(val) }
  end
end

puts invalid_values.sum

puts 'Part 2'

valid_tickets = nearby_tickets.reject do |ticket|
  ticket.any? { |val| ranges.flatten.none? { |r| r.cover?(val) } }
end

def match?(field, val)
  field.any? { |r| r.cover?(val) }
end

def satisfy(fields, tix, ass = [], cant_work = Hash.new { |h, k| h[k] = Set.new })
  # prior assignment is correct
  # base case
  return ass if ass.length == tix[0].length
  # we have more fields to assign; try assigning the next field that matches
  fields.each do |field|
    next if ass.include?(field)

    if tix.all? { |ticket| match?(field, ticket[0]) }
      # this assignment fits
      p depth if depth > 17
      res = satisfy(fields, tix, ass << field, depth + 1)
      return res if res
      # assignment failed
      ass.pop
    end
  end

  # we failed
  nil
end

def vals_match?(vals, field)
  vals.all? { |val| match?(field, val) }
end

def random_satisfy(fields, tix)
  random_ass = fields.shuffle

  500.times do
    new_ass = []
    bad_assignment = false
    random_ass.each_index do |i|
      next if vals_match?(tix.map { |t| t[i] }, random_ass[i])
      bad_assignment = true
      # bad assignment
      # swap with the next bad assignment that fixes this
      (i + 1).upto(fields.length - 1) do |j|
        if !vals_match?(tix.map { |t| t[j] }, random_ass[j]) &&
          vals_match?(tix.map { |t| t[i] }, random_ass[j])
          # this is an improvement!
          random_ass[j], random_ass[i] = random_ass[i], random_ass[j]
          break
        end
      end
    end

    return random_ass unless bad_assignment
  end

  random_satisfy(fields, tix)
end

p random_satisfy(ranges, valid_tickets)
