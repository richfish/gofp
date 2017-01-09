class ArrayUtil
  def self.only_includes?(arr, item)
    arr.include?(item) && arr.one?
  end
end