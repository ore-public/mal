require 'readline'
require_relative 'reader'
require_relative 'printer'
require_relative 'types'
require_relative 'env'

def eval_ast(ast, repl_env)
  case ast
  when Symbol
    repl_env.get(ast)
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

  a0, a1, a2 = ast
  case a0
  when :def!
    repl_env.set(a1, EVAL(a2, repl_env))
  when :'let*'
    let_env = Env.new(repl_env)
    a1.each_slice(2) do |a,e|
      let_env.set(a, EVAL(e, let_env))
    end
    EVAL(a2, let_env)
  else
    el = eval_ast(ast, repl_env)
    f = el[0]
    f.call(*el.drop(1))
  end
end

def PRINT(v)
  pr_str(v)
end


def rep(line, repl_env)
  PRINT(EVAL(READ(line), repl_env))
end


@repl_env = Env.new(nil)
@repl_env.set(:'+', lambda {|a, b| a + b})
@repl_env.set(:'-', lambda {|a, b| a - b})
@repl_env.set(:'*', lambda {|a, b| a * b})
@repl_env.set(:'/', lambda {|a, b| a / b})

while line = Readline.readline('user> ', true)
  begin
    puts rep(line, @repl_env)
  rescue Exception => e
    puts "Error: #{e}"
  end
end