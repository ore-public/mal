class Env
  attr_accessor :data

  def initialize(outer = nil)
    self.data = {}
    @outer = outer
  end

  def set(key, value)
    data[key] = value
  end

  def find(key)
    return self if self.data.key? key
    return @outer.find(key) unless @outer.nil?
    nil
  end

  def get(key)
    env = find(key)
    unless env.nil?
      return env.data[key]
    else
      raise "'#{key}' not found"
    end
  end
end