module ProfileHelper

  def editable?
    #CUSTOMIZE
    true
  end

  def profile_pic_with_sizing(profile, size, height, width)
    image_tag URI.unescape(profile.avatar.url(size.to_sym)), height: height, width: width
  end

  def profile_image_medium(profile)
    image_tag URI.unescape(profile.avatar.url(:medium))
  end

  def show_total(val, label)
    ret = <<-END
      <span class='money'>#{iconf('money')} &nbsp; #{val}</span>
      &nbsp;
      <span style='font-weight:bolder; font-size:16px'> #{label} </span>
    END
    ret.html_safe
  end

  def steps_left_box(title, opts={}, &block)
    top_class = opts[:top_class]
    step1 = opts[:step1] || {}
    step2 = opts[:step2] || {}
    step3 = opts[:step3] || {}
    ret = ""
    ret += "<div class='steps_left #{top_class}'>"
    ret += "<div class='content'>"
    ret += "<div class='title'>#{title}</div>"
    ret += "<a href='#{step1[:link] || '#'}'><div class='step'>#{iconf('circle')} #{step1[:content]}</div></a>" if step1.present?
    ret += "<a href='#{step2[:link] || '#'}'><div class='step'>#{iconf('circle')} #{step2[:content]}</div></a>" if step2.present?
    ret += "<a href='#{step3[:link] || '#'}'><div class='step'>#{iconf('circle')} #{step3[:content]}</div></a>" if step3.present?
    ret += "</div>"
    ret += "#{capture(&block)}" if block_given?
    ret += "</div>"
    ret.html_safe
  end
end