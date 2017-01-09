module RichFormHelper

  def placeholder_form_for(record, *args, &block)
    options = args.extract_options!
    form_for(record, *(args << options.merge(builder: PlaceholderFormFor)), &block)
  end

  def placeholder_remote_form_for(record, *args, &block)
    options = args.extract_options!
    hide = options.delete(:hidden)
    form_for(record, *(args << options.merge({ builder: PlaceholderFormFor, remote: true,
             html: {'data-type' => 'html', style: ('display:none;' if hide)} })), &block)
  end

  def cancel_button(path)
    ret = <<-END
      <div class='inline' style='margin-top:20px'>
        <a class='cancel' href='#{path.call}'>Cancel </a>
      </div>
    END
    ret.html_safe
  end

  def custom_error(id, message)
    content_tag :div, class: "custom_error", id: id, style: 'display:none'  do
      message
    end
  end

  def avatar_field(avatar, f, opts={})
    has_avatar = avatar.present?
    img = avatar ? URI.unescape(avatar.url(:small)) : 'missing2.png'
    extra_style = avatar ? nil : 'width:200px; height:235px'
    ret = <<-END
      <div class='form-group margin-bottom-25px'>
        #{image_tag img, style: "margin-bottom:10px;#{extra_style}"}
        <div></div>
        #{file_field_tag 'asset[image]',  accept: ".png, .jpg, .jpeg, .gif", class: 'input-lg form-control', :'data-url' => opts[:image_url], style: ('display:none' if has_avatar)}

        <span id='success_saved' style='display:none;'>
          #{iconf('check')} Saved
        </span>
        <div id='replace_image' style='#{'display:none;' if !has_avatar}'>
          Replace Image?
        </div>
        <div id='loading_image' style='display:none'>
          #{iconf('spinner fa-spin')} This may take a minute... Feel free to keep editing your profile.
        </div>
        <div id='upload_error' style='display:none'>
          Oops... that didn't work. Please try refreshing and uploading again.
        </div>
      </div>
    END
    ret.html_safe
  end

  def orange_submit_button(label)
    ret = "<div class='form-group' style='margin-top:35px'>"
    ret += "<button class='btn submit_button' type='submit' data-disable-with=\"#{disable_with('Submitting')}\">"
    ret += "<span>#{label}</span>"
    ret += "</button></div>"
    ret.html_safe
  end

  def orange_submit_button_small(label)
    ret = <<-END
      <div class='form-group'>
        <button class='btn submit_button_small' type='submit' data-disable-with=\"#{disable_with('Submitting')}\">
          <span>#{label}</span>
        </button>
      </div>
    END
    ret.html_safe
  end

  def orange_button_small(label)
    ret = orange_submit_button_small(label)
    ret = ret.sub("type='submit'", "type='button'")
    ret.html_safe
  end

  def orange_submit_button_xsmall(label)
    ret = orange_submit_button
    ret.sub('submit_button_small', 'submit_button_xsmall')
    ret.html_safe
  end
end