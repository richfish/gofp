class EnumUtil
  def self.remove_blanks(arr)
    return [] if arr.blank?
    arr.reject do |x|
      ret = x.blank?
      if !ret && x.is_a?(Hash)
        values = x.values
        ret = values.blank?
        ret = remove_blanks(x.values).blank? unless ret
      end
      ret
    end
  end

  def self.deep_remove_blanks(arr_or_hash)
    return arr_or_hash if arr_or_hash.blank?
    ret = [arr_or_hash].flatten.reject do |x|
      reject = x.blank?
      if !reject && x.is_a?(Hash)
        reject = true
        x.each do |k, v|
          new_v = deep_remove_blanks(v)
          if new_v.blank?
            x.delete(k)
          else
            reject = false
            x[k] = new_v
          end
        end
      end
      reject
    end

    unless arr_or_hash.is_a?(Array)
      return ret[0]
    end
    return ret
  end

end
