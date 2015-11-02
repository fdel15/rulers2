class Array
  def sum(start = 0)
    inject(start, &:+)
  end

  def print
    self.each{|e| puts e}
  end

end
