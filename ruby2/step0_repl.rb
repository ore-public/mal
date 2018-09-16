require 'readline'

def READ(v)
  v
end

def EVAL(v)
  v
end

def PRINT(v)
  v
end

def rep(line)
  puts line
end

while line = Readline.readline('user> ', true)
  rep(line)
end
