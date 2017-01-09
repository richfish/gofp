#arg 1 => model
#arg 2 => 'Options' below in string_query format

#TODO could add image exactness but too much
#Options == %w(headline headline_span subheadline_data_1, subheadline_data_2, longer, col_section_1, col_section_2)

task :summary_view_generator => :environment do |t, args|
  if args.extras[0].blank?
    puts "provide model name as fist argument, and then as second arguments, query string format, use the following primatives as keys and desired attribute as value: headline headline_span subheadline_data_1, subheadline_data_2, longer, col_section_1, col_section_2"
    return
  end

  puts "generating your summary view"

  model_name           = args.extras.first
  model_plural         = model_name.underscore.downcase.pluralize
  model_singular       = model_name.underscore.downcase
  fields_hash          = Rack::Utils.parse_nested_query(args.extras[1])

  headline             = "#{model_singular}.#{fields_hash['headline']}"
  headline_span        = "#{model_singular}.#{fields_hash['headline_span']}"
  subheadline_data_1   = "#{model_singular}.#{fields_hash['subheadline_data_1']}"
  subheadline_data_2   = "#{model_singular}.#{fields_hash['subheadline_data_2']}"
  longer               = "#{model_singular}.#{fields_hash['longer']}"
  col_section_1        = "#{fields_hash['col_section_1']}"
  col_section_2        = "#{fields_hash['col_section_2']}"
  col_section_header_1 = col_section_1.to_s.humanize
  col_section_data_1   = "#{model_singular}.#{col_section_1}"
  col_section_header_2 = col_section_2.to_s.humanize
  col_section_data_2   = "#{model_singular}.#{col_section_2}"

  File.open("app/views/#{model_plural}/_#{model_singular}_summary.haml", "w") do |f|
    f.puts <<-END
#{model_singular} = #{model_singular}.decorate
/maybe add associated model too

.#{model_singular}_summary
  .row
    .col-xs-3.col-md-2
      .image
        /custom getting image
        =#profile_image_smaller(your_obj)
    .col-xs-9.col-md-10
      .row
        .col-xs-12
          .headline
            =#{headline}
            %span=#{headline_span}
        .col-xs-12
          .sub_headline
            =#{headline_data_point_1}
            =#{headline_data_point_2}
  .row
    .col-sm-12
      .longer_text
        %i=truncate(longer, length: 200)
  .row.col_section
    .col-sm-6
      %h5=#{col_section_1}
      %p=#{col_section_data_1}
    .col-sm-6
      %h5=#{col_section_2}
      %p=#{col_section_data_2}
  .row.link
    .col-sm-12
      =link_to "\#{iconf('caret-right')} See Full".html_safe, #{model_singular}_path(#{model_singular})
  %hr
    END
  end

  puts "copying over css to #{model_singular}.css.sass"
  File.open("app/assets/stylesheets/view_js/#{model_singular}.css.sass", "a") do |f|
    f.puts <<-END
.#{model_singular}_summary
  .headline
    line-height: 26px
    span
      font-size: 14px
  .image
    float: right
  .longer_text
    font-size: 14px
  .col_section
    font-size: 14px !important
    p
      font-size: 14px
    h5
      color: $mutedPurple
      font-weight: 500
      margin-bottom: 1px
      margin-top: 1px
  .link
    a
      color: black
  .fa-star, .fa-star-half-empty
    color: #605A7F
    END
  end
end

#CSS TO ADD
# .bootcamp_summary
#   .headline
#     line-height: 26px
#     span
#       font-size: 14px
#   .image
#     float: right
#   .longer_text
#     font-size: 14px
#   .col_section
#     font-size: 14px !important
#     p
#       font-size: 14px
#     h5
#       color: $mutedPurple
#       font-weight: 500
#       margin-bottom: 1px
#       margin-top: 1px
#   .link
#     a
#       color: black
#   .fa-star, .fa-star-half-empty
#     color: #605A7F
#TODO generator to append to #{model_singular}.css.sass


