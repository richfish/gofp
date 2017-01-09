class SearchResultsSortPolicy

  attr_accessor :search_entitys

  def initialize(search_entitys)
    @search_entitys = search_entitys
  end

  def sort
    return search_entitys
  end

end
