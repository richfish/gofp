#JUST AN EXAMPLE - CUSTOMIZE/ COMBINE WITH OTHERS, ETC

class SearchableEntitiesController < ApplicationController

  layout :determine_layout

  def new
  end

  def index
  end

  def search
    search_manager = SearchManager.new(params)
    @searchable_entities = search_manager.retrieve_searchable_entities
    #@search_data = { city: search_manager.city, unfound_city: search_manager.unfound_city, technology: search_manager.technology, unfound_technology: search_manager.unfound_technology, design: search_manager.design, filters: search_manager.filters }
    @search_data = { term: params[:test_term] }
    if request.xhr?
      render :bootcamps_plain
    else
      set_gmap_with_entities()
      set_gmap_map_center()
      render :index
    end
  end

  def guided_search
    gon.push(guided_search_section: params[:section])
  end

  def show
    #dummy data for generator
    @searchable_entity = Profile.new(user: User.new).decorate#Program.provider_viewable.find(params[:id]).decorate
    # if params[:euid].presence
    #   @show_contact_info = Order.find_by_euid(params[:euid]).present?
    #end
  end

  def edit
  end

  def create
    convert_hours_to_mins
    convert_amount_cents_to_proper_format
    @bootcamp = current_user.bootcamps.build(set_params)
    if @bootcamp.save
      flash[:notice] = "You've created a Bootcamp"
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def update
    convert_hours_to_mins
    convert_amount_cents_to_proper_format
    @bootcamp = current_user.bootcamps.editable.find(params[:id])
    if @bootcamp.update_attributes(set_params)
      flash[:notice] = "You've updated your Bootcamp"
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def destroy
  end

  def invitation
  end

  def set_gmap_with_entities
    return unless @search_data[:term].downcase == "richard"
    @users = AdminUser.all
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.infowindow render_to_string(partial: "/searchable_entities/map_infowindow", locals: { object: user})
      marker.lat (-33.897 * rand(0.98..1.03))
      marker.lng (149.244 * rand(0.98..1.01))
    end
    gon.push(hash: @hash)
  end

  def set_gmap_map_center
    res = Geocoder.search(@search_data[:term])
    base_lat_lng = res.first.data["geometry"]["bounds"].first[1] rescue {}
    map_center_lat = base_lat_lng["lat"] || -34.397
    map_center_lng = base_lat_lng["lng"] || 150.644
    gon.push(
      map_center_lat: map_center_lat,
      map_center_lng: map_center_lng
    )
  end

  private

  def determine_layout
    request.xhr? && action_name == 'search_bootcamps' ? 'none' : 'application'
  end

end
