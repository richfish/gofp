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

  def page_title
    content_tag :title do
      "Boilerplate!"
    end
  end

  def google_analytics
    render "layouts/google_analytics" if Rails.env.production?
  end

  #e.g. at top of view file put  -view_js :add_user
  def view_js(*script)
    @view_js ||= []
    @view_js << script
    return nil
  end

  def include_view_js
    return unless @view_js
    javascript_include_tag *@view_js.flatten.uniq.map{|x| "view_js/#{x.to_s}" }
  end

  def disable_with(text)
   "<i class='fa fa-spinner fa-spin'></i> #{text}...".html_safe
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

  def spinner_hidden
    iconf('spinner fa-spin', nil, 'display:none; margin-top:10px;')
  end

  def toggle_info_panel(&block)
    ret = <<-END
      <div class='info_panel'>
        <div class='clickable'>
          #{iconf('chevron-down', nil, 'display:none;')}
          #{iconf('question')}
          <span> Explain this to me </span>
        </div>
        <div class='info' style='display:none;'>
          #{capture(&block)}
        </div>
      </div>
    END
    ret.html_safe
  end

  def tooltip(title, classes=nil, placement='right')
    "<i title='#{title}' data-toggle='tooltip' style='color:#333' data-placement=#{placement} class='fa fa-question-circle #{classes}'></i>".html_safe
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
  #     <div class='policies'>
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

  def centered_content_with_faded_heading(txt, &block)
    ret = <<-END
      <div class='row'>
        <div class='col-sm-12'>
          <div class='heading_small'>#{txt}</div>
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
