class Reader
  attr_accessor :tokens
  attr_accessor :position

  def initialize(tokens)
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
  str.scan(re).flatten.reject{|v| v.empty? }
end

def read_atom(reader)
  c = reader.next
  case c
  when /[+-]?\d+/
    c.to_i
  else
    c.to_sym
  end
end

def read_list(reader)
  list = Array.new
  c = reader.next
  if c != '('
    raise "list start not '('"
  end

  while true
    c = read_form(reader)
    break if c.nil?
    list.push(c)
    break if c == ')'
  end
end

def read_form(reader)
  case reader.peek
  when '('
    read_list(reader)
  when nil
    nil
  else
    read_atom(reader)
  end
end

def read_str(str)
  tokens = tokenizer(str)
  read_form(Reader.new(tokens))
end
