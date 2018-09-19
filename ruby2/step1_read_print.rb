require 'readline'

def READ(v)
  v
end

def EVAL(v)
  v
end

def PRINT(v)
  puts v
end

def rep(line)
  PRINT(EVAL(READ(line)))
end

while line = Readline.readline('user> ', true)
  rep(line)
end
