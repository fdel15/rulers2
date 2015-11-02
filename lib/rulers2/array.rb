class Array
  def sum(start = 0)
    begin
      inject(start, &:+)
    rescue
      return nil
    end
  end

  def print
    self.each{|e| puts e}
    return "The sum of the elements is #{self.sum}"
  end

end
