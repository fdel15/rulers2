class Array
  def sum(start = 0)
    inject(start, &:+)
  end

  def print
    self.each{|e| puts e}
    return "The sum of the elements is #{self.sum}"
  end

end
