+ 4 + 5 * (5 * (5 + 3)) + 2

puts 'Part 1'
PLUS = '+'
MULT = '*'
NUMS = ('0'..'9')
LP = '('
RP = ')'

exprs = File.readlines('data18.txt').map { |l| l.chomp.gsub(' ', '') }

def evaluate_simple(expr)
  return expr[0] if expr.length == 1
  num, operation = expr[-1], expr[-2]
  num.send(operation, evaluate_simple(expr[0..-3]))
end

def eval_expr(expr, simple: true)
  expr = ['(', *expr.split(''), ')']
  val_stack = [[]]

  expr.each do |token|
    case token
    when NUMS then val_stack.last << token.to_i
    when PLUS then val_stack.last << token.to_sym
    when MULT then val_stack.last << token.to_sym
    when LP then val_stack << []
    when RP
      last = val_stack.pop
      val_stack[-1] << (simple ? evaluate_simple(last) : evaluate_advanced(last))
    end
  end
  val_stack[0][0]
end

puts exprs.sum { |expr| eval_expr(expr) }

puts 'Part 2'

def evaluate_advanced(expr)
  stack = []
  expr.each do |token|
    if stack[-1] == PLUS.to_sym
      stack.pop # throw away the plus
      stack << stack.pop + token
    else
      stack << token
    end
  end
  evaluate_simple(stack)
end

puts exprs.sum { |expr| eval_expr(expr, simple: false) }
