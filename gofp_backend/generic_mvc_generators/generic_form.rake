#expects two args, model name like 'Bootcamp' and hash of attrs & form-field type like 'preference=radio_button_many&cat=checkbox'
#see reference w/ form_template.haml

task :generic_form => :environment do |t, args|
  model_name        = args.extras.first
  model_plural      = model_name.downcase.pluralize
  model_singular    = model_name.downcase
  fields_hash       = Rack::Utils.parse_nested_query(args.extras[1])

  unless Dir.exists? "app/views/#{model_name.downcase.pluralize}"
    Dir.mkdir "app/views/#{model_name.downcase.pluralize}"
  end

  File.open("app/views/#{model_plural}/_form_basic.haml", "w") do |f|
    f.puts <<-END
-view_js :#{model_singular}
.#{model_singular}
  .title="#\{@#{model_singular}\ ? 'Edit' : 'Create' } Your #{model_name}"

    =toggle_info_panel('Explain this to me') do
      %ul
        %li="All bootcamps follow a 6 week format. (We're exploring other formats too. <a mailto='monkey@monkey.com' target='_blank'> Message us</a> if you want to see something else)".html_safe
        %li You can pick how intensive the bootcamp is, the frequency of meetings and at what times.
        %li Bootcamps are just for one person, for now. You may teach it with other people, but there's a minimum of a 1-to-1 teacher-to-student ratio for now.

    =form_for [current_user, @#{model_singular} ||= #{model_name}.new], html: { multiple: true} do |f|
      =errors(@#{model_singular})

      .title_small The Basics

    END

    fields_hash.each do |field, type|
      field      = field.to_sym #cant interpolate symbol into string w/ the colon..
      type       = type.to_sym
      field_word = field.to_s.split('_').map(&:capitalize).join(' ')

      case type
      when :text_field
        f.puts <<-END
      .form-group
        %h4
          #{field_word}
          =tooltip("This is a basic text field.")
        =f.text_field :#{field}, placeholder: "e.g. Learn Go on Saturdays, for Intermediate or Experienced Developers", class: 'input-lg form-control'

        END
      when :text_area
        f.puts <<-END
      .form-group
        %h4
          #{field_word}
          =tooltip("This is a basic text area field.")
        =f.text_area :#{field}, placeholder: "Git, Shell scripting, VirtualBox, Vagrant, CSS (sass), HTML (haml), client side JavaScript, jQuery, Bootstrap, Redis, Sidekiq, Pusher, Nginx, Jenkins, TDD with MiniTest, etc.", class: 'input-lg form-control', rows: 3

        END
      when :select
        f.puts <<-END
      .form-group
        %h4
          #{field_word}
          =tooltip("Just your basic select field")
        =f.select :#{field}, options_for_select((1..5).to_a, nil), {}, {class: 'input-lg form-control'}

        END
      when :select_inline
        f.puts <<-END
      .form-inline
        .form-group
          #{field_word}
          =tooltip('Here is an inline select field')
        .form-group
          -years = [3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8, 9].map{|x| ["\#{x} years", x]}.prepend("Select years").append("10+ years")
          =f.select :#{field}, options_for_select(years, nil), {}, {class: 'input-lg form-control'}

        END
      when :select_inline_double
        #requires exactly 1 other of same type
        reciprocal_field = fields_hash.select{|k,v| v == "select_inline_double" && k != field.to_s}
        puts "here"
        puts reciprocal_field.inspect
        puts fields_hash.inspect
        reciprocal_field_word = reciprocal_field.keys.first.to_s.split('_').map(&:capitalize).join(' ')
        fields_hash.delete(reciprocal_field.keys.first)
        f.puts <<-END
      .form-inline{ style: 'margin: 30px 0'}
        .form-group.text
          #{field_word}
        .form-group
          -people = (1..3).to_a#Profile::GENDERS.map(&:capitalize)
          =f.select :#{field}, options_for_select(people, nil), {}, {multiple: 'multiple', class: 'form-control input-lg multiselect'}
        .form-group.text{ style: 'margin-left:6px'}
          #{reciprocal_field_word}
        .form-group{ style: 'width: 200px !important' }
          =f.select :#{reciprocal_field.keys.first}, options_for_select(people, nil), {}, {multiple: 'multiple', class: 'form-control input-lg multiselect'}

        END
      when :multiselect
        f.puts <<-END
      .form-group
        %h4 #{field_word}
        %p="<i>Note: Pick up to three core technologies your client will be learning, you probably only want to pick one or two.</i>".html_safe
        =f.select :#{field}, options_for_select((1..10).to_a, nil), {}, {multiple: 'multiple', class: 'form-control input-lg multiselect'}

        END
      when :datepicker
        f.puts <<-END
      .form-group
        %h4 #{field_word}
        =f.text_field :#{field}, placeholder: 'Better have bootstrap-datepicker', class: 'input-lg form-control datepicker'

        END
      when :daterange
        f.puts <<-END
      .form-group
        %h4 #{field_word}
        =f.text_field :#{field}, placeholder: 'Better have bootstrap-daterangepicker',  class: 'input-lg form-control daterangepicker'

        END
      when :daterange_double
        #requires exactly 1 other of same type
        reciprocal_field = fields_hash.select{|k,v| v == "daterange_double" && k != field.to_s}
        reciprocal_field_word = reciprocal_field.keys.first.to_s.split('_').map(&:capitalize).join(' ')
        fields_hash.delete(reciprocal_field.keys.first)
        f.puts <<-END
      .form-inline
        .form-group
          .inner-addon.left-addon
            =iconf('calendar')
            =f.text_field :#{field}, placeholder: 'Start date', required: 'required', class: 'input-lg form-control datepicker', style: "width: 98%"
          .inner-addon.left-addon
            =iconf('calendar')
            =f.text_field :#{reciprocal_field.keys.first}, placeholder: 'Return date', required: 'required', class: 'input-lg form-control datepicker'

        END
      when :money_field
        f.puts <<-END
      .form-group
        %h4
          #{field_word}
          =tooltip("Amount you will earn for your 6 week boilerplate. Fees are charged to clients, not to you. Minimum is $50 (USD).")
        .inner-addon.left-addon
          =iconf('dollar')
        =f.text_field :#{field}, :value => (number_with_precision((f.object.\#{field.to_s}/100 rescue nil), :precision => 2, delimiter: ',') || nil), class: 'form-control input-lg currency_formatter', style: 'padding-left:30px; max-width: 400px;'

        END
      when :check_box
        f.puts <<-END
      .form-group
        .checkbox
          %label
            =f.check_box :#{field}, class: 'input-sm form-control'
            #{field_word}

        END
      when :check_box_inline_many
        f.puts <<-END
      .form-group.inline-checkboxes
        .checkbox
          %label
            =f.check_box :#{field}, {multiple: true, class: 'input-lg form-control', checked: 'checked'}, "1", nil
            #{field_word} A
        .checkbox{ style: 'display-inline'}
          %label
            =f.check_box :#{field}, {multiple: true, class: 'input-lg form-control', checked: 'checked'}, "2", nil
            #{field_word} B
        .checkbox{ style: 'display-inline'}
          %label
            =f.check_box :#{field}, {multiple: true, class: 'input-lg form-control'}, "3", nil
            #{field_word} C

        END
      when :check_box_vertical_many
        f.puts <<-END
      .form-group
        .checkbox
          %label
            =f.check_box :#{field}, {multiple: true, class: 'input-sm form-control'}, "1", nil
            #{field_word} A
        .checkbox
          %label
            =f.check_box :#{field}, {multiple: true, checked: 'checked', class: 'input-sm form-control checkbox'}, "2", nil
            #{field_word} B
        .checkbox
          %label
            =f.check_box :#{field}, {multiple: true, class: 'input-sm form-control checkbox'}, "3", nil
            #{field_word} C

        END
      when :radio_button_inline
        f.puts <<-END
      .form-group
        %h4 #{field_word}
        %p="<i>If you select 'Fixed Start Date', then you will need to set the start date below. Read more about <a href=\#{policies_provider_path(anchor:'rolling_scheudle')} target='_blank'>Rolling vs. Fixed Start policies</a></i>".html_safe
        .center.margin-top-20px
          %label.radio-inline
            =f.radio_button :#{field}, true, checked: true
            #{field_word} Yes
          %label.radio-inline
            =f.radio_button :#{field}, false
            #{field_word} No

        END
      when :radio_button_vertical
        f.puts <<-END
      .form-group
        %h4 #{field_word}
        %p="<i>If you select 'Fixed Start Date', then you will need to set the start date below. Read more about <a href=\#{policies_provider_path(anchor:'rolling_scheudle')} target='_blank'>Rolling vs. Fixed Start policies</a></i>".html_safe
        .margin-top-20px
          .radio.radio-vertical
            %label
              =f.radio_button :#{field}, true, checked: true
              #{field_word} Yes
          .radio.radio-vertical
            %label
              =f.radio_button :#{field}, false
              #{field_word} No

        END
      when :radio_button_many
        f.puts <<-END
      .form-group
        %h4 #{field_word}
        %p="<i>If you select 'Fixed Start Date', then you will need to set the start date below. Read more about <a href=\#{policies_provider_path(anchor:'rolling_scheudle')} target='_blank'>Rolling vs. Fixed Start policies</a></i>".html_safe
        .margin-top-20px
          .radio.radio-vertical
            %label
              =f.radio_button :#{field}, '1'
              #{field_word} A
          .radio.radio-vertical
            %label
              =f.radio_button :#{field}, '2', checked: true
              #{field_word} B
          .radio.radio-vertical
            %label
              =f.radio_button :#{field}, '3'
              #{field_word} C

        END
      when :file_upload
        f.puts <<-END
      .form-group
        %h5 #{field_word} Upload
        =f.file_field :#{field}, class: 'input-lg form-control'

        END
      when :file_upload_ajax
        f.puts <<-END
      Just use this helper for main profile pic type things:
      %br
      =avatar_field(@#{model_singular}.#{field.to_s}, f, :image_url => image_asset_path)
      %br
      Otherwise use this below:
      .margin-bottom-30px
      Ajax file Upload for :#{field}
      .form-group.margin-bottom-25px
        =image_tag URI.unescape(#{field.to_s}.url(:medium)), style: 'margin-bottom:10px'
        %div
        =f.file_field :#{field}, class: 'input-lg form-control', :'data-url' => (opts[:image_url] rescue nil), style: ('display:none' if (false))
        %span#success_saved{:style => "display:none;"}
          =iconf('check')
          Saved
        #replace_image{ style: ('display:none' if (false)) }
          Replace Image?
        #loading_image{ style: "display:none"}
          =iconf('spinner fa-spin')
          This may take a minute... Feel free to keep editing your profile.
        #upload_error{:style => "display:none"}
          Oops... that didn't work. Please try refreshing and uploading again.

        END
      end
    end

  end

  #for testing:
        #rake generate_form['Bootcamp',"cat_text_field=text_field&cat_text_area=text_area&cat_select=select&cat_select_inline=select_inline&cat_select_inline_double=select_inline_double&cat_select_inline_double_two=select_inline_double&cat_multiselect=multiselect&cat_datepicker=datepicker&cat_daterange=daterange&&cat_daterange_double_two=daterange_double&cat_daterange_double=daterange_double&cat_money_field=money_field&cat_check_box=check_box&cat_check_box_inline_many=check_box_inline_many&cat_check_box_vertical_many=check_box_vertical_many&cat_radio_button_inline=radio_button_inline&cat_radio_button_vertical=radio_button_vertical&cat_radio_button_many=radio_button_many&cat_file_upload=file_upload&cat_file_upload_ajax=file_upload_ajax"]


  #generate forms
  #     [ 0] :radio_test_inline,
  #     [ 1] :radio_test_vertical,
  #     [ 2] :basic_text_field,
  #     [ 3] :basic_text_area,
  #     [ 4] :multiselect_field,
  #     [ 5] :date_field,
  #     [ 6] :date_range_field,
  #     [ 7] :date_range_double_field_1,
  #     [ 8] :date_range_double_field_2,
  #     [ 9] :money_field,
  #     [10] :select_field,
  #     [11] :inline_select_field,
  #     [12] :double_inline_select_field_1,
  #     [13] :double_inline_select_field_2,
  #     [14] :many_checkbox_inline,
  #     [15] :many_checkbox_vertical,
  #     [16] :single_checkbox,
  #     [17] :radio_many,
  #     [18] :ajax_file_upload,
  #     [19] :general_file_upload

  #Could pursue enquiring column_types/ column_names & doing part of it automatically?
end
