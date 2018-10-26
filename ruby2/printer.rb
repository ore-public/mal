require_relative 'types'

def pr_str(ast)
  case ast
  when List, Vector, Dictionary
    "#{ast.class::START_SYMBOL}#{ast.map{|v| pr_str(v)}.join(' ')}#{ast.class::END_SYMBOL}"
  when Integer
    ast.to_s
  when Symbol
    ast.to_s
  end
end