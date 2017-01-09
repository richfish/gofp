module ApplicationHelper

  class ObjectHelperBase
    attr_accessor :id

    def initialize(id=nil, opts={}, &block)
      @uuid = UUID.generate
      @id = id || @uuid
      @opts = opts
      @ctx = RequestStore.store.fetch(:current_view_context)
      yield(self) if block_given?
    end

    def self.section_definition(section)
      define_method section do |&block|
        self.instance_variable_set("@#{section}", @ctx.capture(&block))
        return nil
      end
    end

  end

  def linked_logo
    link_to root_path do
      image_tag "passport-wine.png", height: 32
    end
  end

  def link_to_if_with_block(condition, options, html_options={}, &block)
    if condition
      link_to options, html_options, &block
    else
      capture(&block)
    end
  end

  def shorten_link(link)
    link.gsub("http://", "").gsub("https://", "").gsub("www.", "")
  end

  def current_user_has_image_no_profile?
    current_user && current_user.avatar.try(:image).try(:present?) && (current_user.profile.blank? || current_user.profile.new_record?)
  end

  def new_or_edit_link_for_profile
    current_user_has_image_no_profile? ? new_user_profile_path(current_user) : edit_user_profile_path(current_user, current_user.profile)
  end

  def page_title
    content_tag :title do
      "RichardApp"
    end
  end

  def divider_dot
    iconf('circle', nil, 'font-size: 6px;color: rgba(56,56,56,.3); padding: 6px;vertical-align:middle;')
  end

  def local_time_for_user(tz, time)
    #just grab from browser/ IP? or grab based on "where now" city
    #mapping
    # city = user.city
    # tz = CITY_TIMEZONE_HASH[city]
    ActiveSupport::TimeZone[tz].parse(time.to_s)
  end


  def google_analytics
    render "layouts/google_analytics" if Rails.env.production?
  end

  def embedded_svg(filename, options={})
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    if options[:style].present?
      svg['style'] = options[:style]
    end
    doc.to_html.html_safe
  end

  def traveler_type_display(key)
    case key
    when "digital_nomad"
      "Digital Nomad"
    when "studying_abroad"
      "Studying Abroad"
    when "working_abroad"
      "Working Abroad"
    when "being_an_expat"
      "I'm Being an Expat"
    when "just_traveling"
      "Just Traveling"
    when "non_profit_work"
      "Non Profit Worker"
    else
      "None of the above!"
    end
  end

  def checkbox_checked(style=nil)
    embedded_svg "checkbox-checked.svg", class: "checkbox-checked", style: style
  end

  def mobile_menu_toggler_button
    ret = <<-END
      <div class='mobile-menu-toggler__button' onclick="$('.slideout-menu--left').toggleClass('slideout-menu--left--open')">
        <span>
          #{iconf('bars', nil, 'color: rgb(215, 14, 108); font-size: 40px; cursor: pointer;')}
        </span>
      </div>
    END
    ret.html_safe
  end  

  def checkbox_unchecked(style=nil)
    embedded_svg "checkbox-unchecked.svg", class: "checkbox-unchecked", style: style
  end

  def encode_verifiable_msg(data)
    ActiveSupport::MessageVerifier.new(Rails.application.config.secret_token).generate(data)
  end

  def decode_verifiable_msg(data)
    ActiveSupport::MessageVerifier.new(Rails.application.config.secret_token).verify(data)
  end

  #e.g. at top of view file  -view_js :add_user
  def view_js(*script)
    @view_js ||= []
    @view_js << script
    return nil
  end

  def include_view_js
    return unless @view_js
    javascript_include_tag *@view_js.flatten.uniq.map{|x| "view_js/#{x.to_s}" }
  end

  def view_css(*sheet)
    @view_css ||= []
    @view_css << sheet
    return nil
  end

  def include_view_css(*sheet)
    return unless @view_css
    stylesheet_link_tag *@view_css.flatten.uniq.map{|x| "view_css/#{x.to_s}" }
  end

  def disable_with(text='Submitting')
   "<i class='fa fa-spinner fa-spin'></i> #{text}...".html_safe
  end

  def disable_with_short(text=nil)
    "<i class='fa fa-spinner fa-spin'></i> #{text}".html_safe
  end

  def icon(glyph, title=nil, style=nil)
    "<span title='#{title}' class='glyphicon glyphicon-#{glyph}' style='#{style}'></span>".html_safe
  end

  def iconf(classes, title=nil, style=nil)
    "<i title='#{title}' class='fa fa-#{classes}' style='#{style}'></i>".html_safe
  end

  def spinner
    iconf('spinner fa-spin')
  end

  def city_display_formatting(city)
    #supplement with more rules
    case city
    when "San Francisco Bay Area"
      "San Francisco Bay Area"
    else
      city
    end
  end

  def set_color(hex, var)
    ret = <<-END
    <div class='color' style='background-color:#{hex}'>
    </div>
    <div>
      #{hex}
      <br />
      #{var}
    </div>
    END
    ret.html_safe
  end

  def annonymous_profile_pic_small
    image_tag "missing2.png", height: 80, width: 80, style: 'border-radius:50%'
  end

  def spinner_hidden
    iconf('spinner fa-spin', nil, 'display:none; margin-top:10px;')
  end

  def toggle_info_panel(heading=nil, &block)
    ret = <<-END
      <div class='info_panel'>
        <div class='clickable'>
          #{iconf('chevron-down', nil, 'display:none;')}
          #{iconf('question')}
          <span> #{heading || 'Explain this to me'} </span>
        </div>
        <div class='info' style='display:none;'>
          #{capture(&block)}
        </div>
      </div>
    END
    ret.html_safe
  end

  def tooltip(title, classes=nil, placement='top')
    title = title.gsub("'", '&#39')
    "<i title='#{title}' data-toggle='tooltip' style='font-size: 18px;color:rgb(93,93,93);' data-placement=#{placement} class='fa fa-question-circle #{classes}'></i>".html_safe
  end

  def tooltip_on_obj(title, obj, classes=nil, placement='top')
    title = title.gsub("'", '&#39')
    "<i title='#{title}' data-toggle='tooltip' data-placement=#{placement} class='#{classes}'>#{obj}</i>".html_safe
  end

  def errors(target)
    render "shared/error_messages", target: target
  end

  def embedded_map_url(location)
    "https://www.google.com/maps/embed/v1/place?key=#{EMBED_KEY}&q=#{location}".gsub(' ', '%20')
  end

  def regular_map_url(location)
    "http://maps.google.com/?q=#{location}".gsub(' ', '%20')
  end


  # def relevant_artist_policies
  #   ret = <<-END
  #     <div class='policies'>`
  #       <div class='title'>
  #         Relevant policies
  #       </div>
  #       <ul>
  #         <li>#{link_to 'Your Obligations as a Provider', policies_provider_path(anchor: 'obligations_provider')}</li>
  #         <li>#{link_to 'Payments', policies_provider_path(anchor: 'payouts_policy')}</li>
  #         <li>#{link_to 'Cancellations & Refunds', policies_provider_path(anchor: 'cancellation_refunds_policy') }</li>
  #         <li>#{link_to 'Privacy', policies_provider_path(anchor: 'privacy_policy')}</li>
  #         <li>#{link_to 'Disputes', policies_provider_path(anchor: 'disputes_policy')}</li>
  #         <li>#{link_to 'Your Discoverability', policies_provider_path(anchor: 'discoverability_policy')}</li>
  #         <li>#{link_to 'Confirmation & Auto-Cancellation', policies_provider_path(anchor: 'confirmations_policy')}</li>
  #         <li>#{link_to 'Profile Stuff', policies_provider_path(anchor: 'profile_policy')}</li>
  #
  #       </ul>
  #     </div>
  #   END
  #   ret.html_safe
  # end

  def centered_content_with_faded_heading(txt, opts={}, &block)
    sub_heading_txt = opts[:sub_heading].presence
    sub_heading_html = "<div class='sub_heading_small'>#{sub_heading_txt}</div>"
    ret = <<-END
      <div class='row'>
        <div class='col-sm-12'>
          <div class='heading_small'>#{txt}</div>
          #{sub_heading_html}
        </div>
      </div>
      <div class='row center'>
        <div class='col-sm-12'>
          #{capture(&block)}
        </div>
      </div>
    END
    ret.html_safe
  end

  def green_check_mark(styles=nil)
    iconf('check', nil, "color:#43D40A; #{styles}")
  end

  def include_custom_alerts
   ret = "<div id='global_alert_box' style='display:none'><div class='content'><p></p></div></div>"
   ret += "<div id='global_confirm_box' style='display:none'><div class='content'><p></p></div></div>"
   ret.html_safe
  end

end
