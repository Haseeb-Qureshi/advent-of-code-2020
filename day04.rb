lines = File.readlines('data04.txt').map(&:chomp) << ""
REQUIRED_KEYS = %w(byr iyr eyr hgt hcl ecl pid)
NON_REQUIRED_KEYS = ['cid']

passports = []
current_passport = {}
lines.each do |line|
  if line.empty?
    passports << current_passport
    current_passport = {}
  else
    line.split.each do |pair|
      k, v = pair.split(':')
      current_passport[k] = v
    end
  end
end

def has_required_keys(passport)
  passport.values_at(*REQUIRED_KEYS).all?
end

valid_passports = passports.select { |passport| has_required_keys(passport) }

puts valid_passports.count

puts 'Part 2'

# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.
EYE_COLORS = %w(amb blu brn gry grn hzl oth)

def validate(passport)
  byr, iyr, eyr, hgt, hcl, ecl, pid, cid = passport.values_at(
    *%w(byr iyr eyr hgt hcl ecl pid cid)
  )
  return false unless byr.to_i.between?(1920, 2002)
  return false unless iyr.to_i.between?(2010, 2020)
  return false unless eyr.to_i.between?(2020, 2030)
  if hgt.end_with?('cm')
    return false unless hgt.match(/^\d+cm$/)
    cm = hgt.split('cm')[0]
    return false unless cm.to_i.between?(150, 193)
  elsif hgt.end_with?('in')
    return false unless hgt.match(/^\d+in$/)
    inches = hgt.split('in')[0]
    return false unless inches.to_i.between?(59, 76)
  else
    return false
  end
  return false unless hcl.match(/^\#[0123456789abcdef]{6}$/)
  return false unless EYE_COLORS.include?(ecl)
  return false unless pid.match(/^[0123456789]{9}$/)
  true
end

puts valid_passports.count { |passport| validate(passport) }
