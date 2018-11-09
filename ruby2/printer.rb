require_relative 'types'

def pr_str(ast)
  case ast
  when List, Vector, Dictionary
    "#{ast.class::START_SYMBOL}#{ast.map {|v| pr_str(v)}.join(' ')}#{ast.class::END_SYMBOL}"
  when Hash
    result = ast.map {|k, v| [pr_str(k), pr_str(v)]}
    '{' + result.join(' ') + '}'
  else
    ast.to_s
  end
end