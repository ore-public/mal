def pr_str(ast)
  case ast
  when Array
    '(' + ast.map{|v| pr_str(v)}.join(' ') + ')'
  when Integer
    ast.to_s
  when Symbol
    ast.to_s
  end
end