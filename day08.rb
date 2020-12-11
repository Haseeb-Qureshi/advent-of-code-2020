require 'set'
require 'pry'
require 'pp'

ACC = 'acc'
JMP = 'jmp'
NOP = 'nop'

puts "Part 1"

def run_until_loop(source)
  state = { acc: 0, i: 0 }
  previous_lines = Set.new()
  loop do
    previous_lines << state[:i]
    state = run_instruction(state, source)
    return state[:acc] if previous_lines.include?(state[:i])
  end
end

def run_instruction(state, source)
  acc, i = state[:acc], state[:i]
  command, v = source[state[:i]].split
  value = v.to_i

  case command
  when ACC
    acc += value
    i += 1
  when NOP
    i += 1
  when JMP
    i += value
  else
    raise "wtf is #{command}"
  end
  { acc: acc, i: i }
end

source = File.readlines('data08.txt').map(&:chomp)
puts run_until_loop(source)

puts "Part 2"

def fix_corruption(source)
  state = { acc: 0, i: 0 }
  previous_lines = Set.new()
  previous_states = []
  loop do
    previous_lines << state[:i]
    previous_states << state
    state = run_instruction(state, source)
    break if previous_lines.include?(state[:i])
  end

  loop do
    # rewind and keep trying to branch from a previous state
    state = previous_states.pop
    previous_lines.delete(state[:i])
    op, _ = source[state[:i]].split
    next if op == ACC

    # here's a candidate branching path!
    # save state and rewrite the source
    branching_idx = state[:i]
    previous_lines_at_branch = previous_lines.dup
    source[branching_idx].gsub!(*(op == JMP ? [JMP, NOP] : [NOP, JMP]))
    loop do
      # try out the branch
      state = run_instruction(state, source)
      break if previous_lines.include?(state[:i])
      return state[:acc] if state[:i] >= source.length
      previous_lines << state[:i]
    end
    # no bueno, undo...
    source[branching_idx].gsub!(*(op == NOP ? [JMP, NOP] : [NOP, JMP]))
    previous_lines = previous_lines_at_branch
  end
end

puts fix_corruption(source)
