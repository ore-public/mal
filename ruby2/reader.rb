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

def read_str(str)
  tokens = tokenizer(str)
  read_form(Reader.new(tokens))
end

def tokenizer(str)
  re = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*)/
  str.scan(re).flatten
end
