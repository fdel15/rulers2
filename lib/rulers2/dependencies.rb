class Object
  def self.const_missing(c)
    require Rulers2.to_underscore(c.to_s)
    Object.const_get(c)
  end
end