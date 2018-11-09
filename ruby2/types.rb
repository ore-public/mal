class List < Array
  START_SYMBOL = '('
  END_SYMBOL = ')'
end

class Vector < Array
  START_SYMBOL = '['
  END_SYMBOL = ']'
end

class Dictionary < Array
  START_SYMBOL = '{'
  END_SYMBOL = '}'

  def to_hash
    Hash[self.each_slice(2).to_a]
  end
end