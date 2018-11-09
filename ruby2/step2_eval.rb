require 'readline'
require_relative 'reader'
require_relative 'printer'
require_relative 'types'

def eval_ast(ast, repl_env)
  case ast
  when Symbol
    raise "'#{ast}' not found." unless repl_env.has_key?(ast)
    repl_env[ast]
  when List
    List.new(ast.map {|v| EVAL(v, repl_env)})
  when Vector
    Vector.new(ast.map {|v| EVAL(v, repl_env)})
  when Dictionary
    new_h = {}
    ast.to_hash.each {|k, v| new_h[EVAL(k, repl_env)] = EVAL(v, repl_env)}
    new_h
  else
    ast
  end
end

def READ(v)
  read_str(v)
end

def EVAL(ast, repl_env)
  return eval_ast(ast, repl_env) unless ast.is_a?(List)
  return ast if ast.empty?

  el = eval_ast(ast, repl_env)
  f = el[0]

  f.call(*el.drop(1))
end

def PRINT(v)
  pr_str(v)
end

def rep(line)
  repl_env = {
      '+': lambda {|a, b| a + b},
      '-': lambda {|a, b| a - b},
      '*': lambda {|a, b| a * b},
      '/': lambda {|a, b| a / b}
  }
  PRINT(EVAL(READ(line), repl_env))
end

while line = Readline.readline('user> ', true)
  begin
    puts rep(line)
  rescue Exception => e
    puts "Error: #{e}"
  end
end