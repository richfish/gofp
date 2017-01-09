class StringUtil
  def self.random(length)
    (0...length).map { 65.+(rand(26)).chr }.join
  end

  def self.to_bool(str)
    return false unless str
    (str =~ (/(true|t|yes|y|1|on)$/i)) == 0
  end

  def self.capitalize_first_letters(str)
    str.split.map(&:capitalize).join(' ')
  end
end