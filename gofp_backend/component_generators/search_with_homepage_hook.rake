#pass model name Camel case
#assumes existence of all basic stuff for searched model...
#pass searchable fields as additional arguments w/ the type of field, query style, lowercase snake
#FORK --> diff model for datetime search; setting something in session...
#additions... accept more fine grain input over associated models/ scopes etc so fully functional
#simple home-page form, on results page, have more fine detauls options/ advanced search form there.

#form type options --> :text_field, :select, :multiselect, :datepicker, :text_field_typeahead

#make sure have css for home page form in place

#lets make a second sign up section in addition to the search

#add "no result found" logic

#TODO --> pagination generators


#adds form to home page
#search and sort managers

task :search_with_homepage_hook => :environment do |t, args|

  allowable_types = [:text_field, :select, :multiselect, :datepicker, :text_field_typeahead]
  search_fields_hash = Rack::Utils.parse_nested_query(args.extras[1])
  unless search_fields_hash.values.all?{|x| x.to_sym.in? allowable_types}
    puts "you entered invalid form types, please try again."
    return
  end

  model_name     = args.extras.first
  search_fields  = search_fields_hash.keys
  model_plural   = model_name.underscore.downcase.pluralize
  model_singular = model_name.underscore.downcase

  #controller
  puts "updating controller of searched model"
  search_data_hash_str = ""
  search_fields.each do |field|
    search_data_hash_str << "#{field}: search_manager.#{field}, "
  end
  search_data_hash_str.slice!(-2..-1)
  search_data_hash_str.prepend('{').<<('}')

  tempfile = File.open('file.tmp', "w")
  controller = File.new("app/controllers/#{model_plural}_controller.rb")
  controller.each.with_index do |line, i|
    tempfile<<line
    if i == 1 #inserts after this line, not at that line...
      tempfile << <<-END
  def search_#{model_plural}
    #may want two paths if doing a time search
    search_manager = #{model_name}SearchManager.new(params)
    @#{model_plural} = search_manager.retrieve_#{model_plural}
    #session[:city] = search_manager.city
    @search_data = #{search_data_hash_str}
    render :index
  end

  #search results
  def index
  end

      END
    end
  end
  controller.close
  tempfile.close
  FileUtils.mv("file.tmp", "app/controllers/#{model_plural}_controller.rb")


  #search manager
  puts "creating search manager for lib"
  search_fields_with_unfound = search_fields.map{|x| ["#{x}", "unfound_#{x}"] }.flatten
  attr_accessor_str = search_fields_with_unfound.map{|x| ":#{x}"}.join(", ")
  init_method_strs = ""
  search_fields.each.with_index do |field, i|
    init_method_strs << "@#{field} = find_correct_#{field}(params[:#{field}]) #{"\n\t\t" unless i == search_fields.size - 1}"
  end
  unfound_string = ""
  search_fields_with_unfound.select{|x| x['unfound_']}.each.with_index do |field, i|
    unfound_string << (i == search_fields.size - 1 ? "@#{field}" : "@#{field} || ")
  end
  scope_string = ""
  search_fields.each do |field|
    scope_string << ".for_#{field}(field)"
  end
  File.open("lib/#{model_singular}_search_manager_test.rb", "w") do |f|
    f.puts <<-END
class #{model_name}SearchManager

  attr_accessor #{attr_accessor_str}

  def initialize(params)
    #{init_method_strs}
  end

  def retrieve_bootcamps
    return if #{unfound_string}
    #{model_plural} = smart_#{model_plural}_retrieval
    #{model_name}SearchResultsSortPolicy.new(#{model_plural}).sort
  end

  private

  def smart_#{model_plural}_retrieval
    #{model_name}.includes(association).some_base_scope#{scope_string}
  end

    END
    search_fields.each do |field|
      f.puts <<-END
  def find_correct_#{field}("#{field}_raw")
    #{field}_found = FuzzyMatch.new(SOME_ARR).find(#{field}_raw) #or something
    @unfound_#{field} = #{field}_raw if #{field}_found.nil?
    #{field}_found
  end\n\t\t
      END
    end
  end


  puts "sort manager"
  File.open("lib/#{model_name}_search_results_sort_manager.rb", "w") do |f|
    f.puts <<-END
class #{model_name}SearchResultsSortPolicy

  attr_accessor :#{model_plural}

  def initialize(#{model_plural})
    @#{model_plural} = #{model_plural}
  end

  def sort
    #add
    return #{model_plural}
  end

end
    END
  end


  puts "home page search integration"
  #just appending to the end, should be fine if home page = boiler page
  #by default is all inline!

  #delete last two lines which are old sign up button
  tempfile = File.open("file.tmp", "w")
  hookfile = File.new("app/views/welcome/_hook.haml")
  count = File.readlines("app/views/welcome/_hook.haml").count
  hookfile.each.with_index do |line, i|
    unless (i == count - 2) || (i == count - 1)
      tempfile<<line
    end
  end
  tempfile.close
  hookfile.close
  FileUtils.mv("file.tmp", "app/views/welcome/_hook.haml")

  File.open("app/views/welcome/_hook.haml", "a") do |f|
    f.puts <<-END
      .call_to_action
        =form_tag search_path do
          .form-inline{ style: 'font-size:24px' }
          END

      search_fields_hash.each do |field, type|
        case type.to_sym
        when :text_field
          f.puts <<-END
            .form-group
              #{field}
            .form-group
              =text_field_tag '#{field}', nil, class: 'form-control input-lg', placeholder: '#{field}'
          END
        when :text_field_typeahead
          f.puts <<-END
            .form-group
              #{field}
            .form-group
              =text_field_tag "#{field}", nil, class: 'form-control input-lg typeahead', placeholder: '#{field}'
          END
        when :select
          f.puts <<-END
            .form-group
              #{field}
            .form-group
              =select_tag '#{field}', options_for_select((1..5).to_a, nil), {class: 'form-control input-lg selectpicker'}
          END
        when :multiselect
          f.puts <<-END
            .form-group
              #{field}
            .form-group
              =select_tag "#{field}", options_for_select((1..10).to_a, nil), {multiple: 'multiple', class: 'form-control input-lg multiselect'}
            END
        when :datepicker
          f.puts <<-END
            .form-group
              #{field}
            .form-group
              =f.text_field '#{field}', placeholder: '#{field}', class: 'input-lg form-control datepicker'
          END
        end
      end

      f.puts <<-END
          %button.submit_button{ style: 'submit', :'data-disable-with' => disable_with('Searching')}
            %span Get Started

      .downarrow{ style: 'display:none'}
        .scroll_down
          =iconf('chevron-circle-down')
      END
   end



  puts "add route for search"
  #append it sort of towards bottom
  tempfile = File.open('file.tmp', "w")
  routes = File.new("config/routes.rb")
  count = File.readlines("config/routes.rb").count
  routes.each_with_index do |line, i|
    tempfile << line
    if i == (count - 5) #some padding from bottom
      tempfile << <<-END
  post 'search' => '#{model_plural}#search_#{model_plural}'
      END
    end
  end
  tempfile.close
  routes.close
  FileUtils.mv('file.tmp', 'config/routes.rb')


  #assume partial has already been copied over
  puts "add for_providers section to relocate sign up button"
  File.open("app/views/welcome/index.haml", "a") do |f|
    f.puts <<-END
\n
=render "welcome/for_providers"
    END
  end

  #set up basic partial view for search result
  puts "basic partial for search results"
  File.open("app/views/#{model_plural}/_#{model_singular}_summary_search.haml", "w") do |f|
    f.puts <<-END
%h4 JUST SUMMARY PARTIAL; FILL OUT
    END
  end

  #add index page with basic logic for search
  #assumes this page is blank
  puts "flesh out default index page for search"
  search_result_var_list_left = ""
  search_fields.each do |field|
    search_result_var_list_left << "unfound_#{field}, #{field}, "
  end
  search_result_var_list_left.slice!(-2..-1) #should be comma + space
  search_result_var_list_left_right = search_result_var_list_left + " = "
  search_fields.each do |field|
    search_result_var_list_left_right << "@search_data[:unfound_#{field}], @search_data[:#{field}], "
  end
  search_result_var_list_left_right.slice!(-2..-1)
  File.open("app/views/#{model_plural}/index.haml", "a") do |f|
    f.puts <<-END
-#{search_result_var_list_left_right}

.search
  / All this is very city dependent
  -city = city_display_formatting(city) rescue 'Cleveland'
  -title = unfound_city ? "We didn't recognize \#{unfound_city.presence rescue "Nowhere"}" : "Better Bootcamps in \#{city}"
  .center.margin-bottom-40px.margin-top-20px
    .title=title

.row
  -if @#{model_plural}.blank?
    .center
      .mega_title{ style: 'margin-top: 90px' } No Results Found
      %p="<a href='\#{root_path}'>\#{iconf('search')} Search for a different technology or city</a>".html_safe

  -else
    -@#{model_plural}.each do |#{model_singular}|
      .col-sm-6.col-md-4.clearfix
        =render "#{model_plural}/#{model_singular}_summary_search", #{model_singular}: #{model_singular}

    END
  end

  #add citystuff to before_filter on welcome page

  #add manifest file stuff...

end



