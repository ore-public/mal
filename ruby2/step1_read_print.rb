require 'readline'
require_relative 'reader'
require_relative 'printer'

def READ(v)
  read_str(v)
end

def EVAL(v)
  v
end

def PRINT(v)
  pr_str(v)
end

def rep(line)
  PRINT(EVAL(READ(line)))
end

while line = Readline.readline('user> ', true)
  puts rep(line)
end
