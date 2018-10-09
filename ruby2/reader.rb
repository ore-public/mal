class Reader
  attr_accessor :tokens
  attr_accessor :position

  def initializer(tokens)
    self.tokens = tokens
    self.position = 0
  end

  def next
    self.position += 1
    self.tokens[self.position - 1]
  end

  def peek
    self.tokens[self.position]
  end
end

def tokenizer(str)
  re = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*)/
  str.scan(re).flatten
end

def read_atom(reader)

end

def read_list(reader)
  list = Array.new
  c = reader.next
  if c == '('
    raise "list start not '('"
  end

  while true
    c = read_form(reader)
    list.push(c)
    break if c == ')'
  end
end

def read_form(reader)
  case reader.peek
  when '('
    read_list(reader)
  else
    read_atom(reader)
  end
end

def read_str(str)
  tokens = tokenizer(str)
  read_form(Reader.new(tokens))
end

