require_relative 'types'

def pr_str(ast)
  case ast
  when List
    "(#{ast.map{|v| pr_str(v)}.join(' ')})"
  when Vector
    "[#{ast.map{|v| pr_str(v)}.join(' ')}]"
  when Dictionary
    "{#{ast.map{|v| pr_str(v)}.join(' ')}}"
  when Integer
    ast.to_s
  when Symbol
    ast.to_s
  end
end