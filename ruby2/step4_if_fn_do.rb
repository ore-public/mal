require 'readline'
require_relative 'reader'
require_relative 'printer'
require_relative 'types'
require_relative 'env'
require_relative 'core'

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

  a0, a1, a2, a3 = ast
  case a0
  when :def!
    repl_env.set(a1, EVAL(a2, repl_env))
  when :'let*'
    let_env = Env.new(repl_env)
    a1.each_slice(2) do |a,e|
      let_env.set(a, EVAL(e, let_env))
    end
    EVAL(a2, let_env)
  when :do
    el = eval_ast(ast.drop(1), repl_env)
    return el.last
  when :if
    cond = EVAL(a1, repl_env)
    if cond
      return EVAL(a2, repl_env)
    else
      return nil if a3 == nil
      return EVAL(a3, repl_env)
    end
  when :'fn*'
    return lambda do |*args|
      EVAL(a2, Env.new(repl_env, a1, List.new(args)))
    end
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


repl_env = Env.new(nil)
@ns.each do |name, body|
  repl_env.set(name, body)
end

rep("(def! not (fn* (a) (if a false true)))", repl_env)
while line = Readline.readline('user> ', true)
  begin
    puts rep(line, repl_env)
  rescue Exception => e
    puts "Error: #{e}\n#{e.backtrace.join("\n")}"
  end
end