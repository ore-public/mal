require_relative 'types'

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
  when /^-?\d+$/
    c.to_i
  else
    c.to_sym
  end
end

def read_list(reader, klass, start = '(', last = ')')
  list = klass.new
  c = reader.next
  if c != start
    raise "list start not '#{start}'"
  end

  while true
    c = read_form(reader)
    break if c.nil?
    break if c.to_s == last
    list.push(c)
  end

  list
end

def read_form(reader)
  case reader.peek
  when '('
    read_list(reader, List)
  when '['
    read_list(reader, Vector, '[', ']')
  when '{'
    read_list(reader, Dictionary, '{', '}')
  when "'"
    reader.next
    List.new [:quote, read_form(reader)]
  when '`'
    reader.next
    List.new [:quasiquote, read_form(reader)]
  when '~'
    reader.next
    List.new [:unquote, read_form(reader)]
  when '@'
    reader.next
    List.new [:deref, read_form(reader)]
  when '~@'
    reader.next
    List.new [:'splice-unquote', read_form(reader)]
  when '^'
    reader.next
    meta = read_form(reader)
    List.new [:'with-meta', read_form(reader), meta]
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
