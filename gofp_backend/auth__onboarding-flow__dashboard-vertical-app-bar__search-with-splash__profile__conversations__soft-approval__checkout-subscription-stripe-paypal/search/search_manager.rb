#JUST AN EXAMPLE - CUSTOMIZE

class SearchManager

  attr_accessor :unfound_city, :unfound_technology, :city, :technology, :tech_original, :design, :page, :filters

  def initialize(params)
  #  @city          = find_correct_city(params[:city])
    @term = params[:test_term]
    @tech_original = params[:technology_field]
    @technology    = params[:technology_field].try(:downcase)
    @page          = params[:page]
    @filters       = params[:filters].try(:squish).try(:split, " ").presence
  end

  def retrieve_searchable_entities
    #stuff just for generator display
    if @term.downcase == "richard"
      return AdminUser.page(nil).all
    else
      return nil
    end
    searchable_entitys = filters.present? ? smart_filtered_search : smart_searchable_entity_retrieval
    SearchResultsSortPolicy.new(searchable_entitys).sort
  end

  private

  def in_filters?(val)
    filters.include? val
  end

  def all_filters_present?
     %w( beginner advanced power extended ).all?{|x| x.in? filters }
  end

  def search_both_power_filters?
    (in_filters?('power') && in_filters?('extended')) || (!in_filters?('power') && !in_filters?('extended'))
  end

  def smart_filtered_search
    #a little tedious b/c need to return an AR relation object for kaminari
    programs_base = smart_searchable_entity_retrieval
    return programs_base if all_filters_present?

    if in_filters?('beginner') && !in_filters?('advanced')
      if search_both_power_filters?
        programs_base.where(level: Program::LEVEL_BEGINNER)
      else
        type = in_filters?('power') && !in_filters?('extended') ? PowerSession : searchable_entity
        programs_base.where(level: Program::LEVEL_BEGINNER, type: type)
      end
    elsif in_filters?('advanced') && !in_filters?('beginner')
      if search_both_power_filters?
        programs_base.where(level: [Program::LEVEL_INTERMEDIATE, Program::LEVEL_ADVANCED])
      else
        type = in_filters?('power') && !in_filters?('extended') ? PowerSession : searchable_entity
        programs_base.where(level: [Program::LEVEL_INTERMEDIATE, Program::LEVEL_ADVANCED], type: type)
      end
    else #either both advance/beginner filters are present or absent
      if search_both_power_filters?
        programs_base
      else
        type = in_filters?('power') && !in_filters?('extended') ? PowerSession : searchable_entity
        programs_base.where(type: type)
      end
    end
  end

  def smart_searchable_entity_retrieval
    bcs_raw = Program.includes(:user).page(page)
    bcs_raw.bookable.for_city(city).for_technology(technology)
  end

  def find_correct_technology(tech_raw)
    tech_found = FuzzyMatch.new(CORE_TECHNOLOGIES_ARRAY).find(tech_raw)
    @unfound_technology = tech_raw if tech_found.nil?
    tech_found
  end

  def find_correct_city(city_raw)
    city_raw = city_raw.downcase
    city = CITY_RULES[city_raw] || FuzzyMatch.new(CITIES).find(city_raw)
    @unfound_city = city_raw if city.nil?
    city
  end


end
