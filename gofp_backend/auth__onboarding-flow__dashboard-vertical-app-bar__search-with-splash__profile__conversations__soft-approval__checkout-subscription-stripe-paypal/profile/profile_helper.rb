module ProfileHelper

  def profile_pic_with_sizing(profile, size, height, width)
    img = profile.user.avatar ? URI.unescape(profile.user.avatar.image.url(size.to_sym)) : 'missing2.png'
    image_tag img, height: height, width: width
  end

  def profile_image_medium(profile)
    img = profile.user.avatar ?  URI.unescape(profile.user.avatar.image.url(:medium)) : "missing2.png"
    image_tag img
  end

  def profile_image_small(profile)
    img = profile.user.avatar ? URI.unescape(profile.user.avatar.image.url(:small)) : 'missing2.png'
    image_tag img
  end

  def profile_image_small2(profile)
    image_tag URI.unescape(profile.user.avatar.image.url(:small)), height: 160, width: 130
  end

  def profile_image_small_first_visit
    image_tag "missing2.png", height: 160, width: 130
  end

  def profile_image_smaller(profile)
    img = profile.user.avatar ? URI.unescape(profile.user.avatar.image.url(:small)) : 'missing2.png'
    image_tag img, height: 120, width: 120, style: 'border-radius:50%'
  end

  def profile_image_xsmall(profile)
    img = profile.user.avatar ? URI.unescape(profile.user.avatar.image.url(:small)) : 'missing2.png'
    image_tag img, height: 80, width: 80, style: 'border-radius:50%'
  end

  def profile_image_xxsmall(profile)
    img = profile.user.avatar ? URI.unescape(profile.user.avatar.image.url(:small)) : 'missing2.png'
    image_tag img, height: 20, width: 20, style: 'border-radius:50%'
  end

  def show_total(val, label)
    ret = <<-END
      <span class='money'>#{iconf('money')} &nbsp; #{val}</span>
      &nbsp;
      <span style='font-weight:bolder; font-size:16px'> #{label} </span>
    END
    ret.html_safe
  end

  def levels_badge(level)
    ret <<-END
    END

  end

  def steps_left_box(title, opts={}, &block)
    top_class = opts[:top_class]
    step1 = opts[:step1] || {}
    step2 = opts[:step2] || {}
    step3 = opts[:step3] || {}
    ret = ""
    ret += "<div class='steps_left_abs'>"
    ret += "<div class='content #{top_class}'>"
    ret += "<div class='title'>#{title}</div>"
    ret += "<div class='steps_list'>"
    ret += "<a href='#{step1[:link] || '#'}'><div class='step'>#{iconf('circle') unless opts[:no_circle]} #{step1[:content]}</div></a>" if step1.present?
    ret += "<a href='#{step2[:link] || '#'}'><div class='step'>#{iconf('circle')} #{step2[:content]}</div></a>" if step2.present?
    ret += "<a href='#{step3[:link] || '#'}'><div class='step'>#{iconf('circle')} #{step3[:content]}</div></a>" if step3.present?
    ret += "</div>"
    ret += "</div>"
    ret += "#{capture(&block)}" if block_given?
    ret += "</div>"
    ret.html_safe
  end

  def no_stars_on_0_reviews_str
    "#{num_to_stars(5)} on <span><a href='#' class='b-more'>0 reviews</a></span>".html_safe
  end

  def stars_reviews_str
    num_reviews = pluralize(current_user.reviews_count, 'review')
    "#{num_to_stars(current_user.avg_overall) } on <span><a href='#{reviews_path}' class='b-more'>#{num_reviews}</a></span>".html_safe
  end



  def sample_stars_reviews_str
    "#{num_to_stars(5)} on <span><a href='#' class='b-more'>4 reviews</a></span>".html_safe
  end
end
