class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #force_ssl if: -> { Rails.env.production? }

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  def embed_map_url
    "https://www.google.com/maps/embed/v1/place?key=#{EMBED_KEY}&q="
  end

  def load_resource(name, param_name = nil, &block)
    id = params[param_name] || params["#{name.to_s}_id".to_sym] || params[:id]
    return nil unless id
    resource = block.call(id)
    instance_variable_set("@#{name.to_s}", resource)
  end

  def render_forbidden_error
    render(file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false)
  end

  def verify_security_key(key)
    if key == params[:euid]
      true
    else
      render_forbidden_error
      false
    end
  end

  def local_time_for_user(user, time)
    city = user.city
    tz = CITY_TIMEZONE_HASH[city]
    ActiveSupport::TimeZone[tz].parse(time.to_s)
  end

  def local_time_now(user)
    local_time_for_user(user, Time.now)
  end

  def encode_verifiable_msg(data)
    ActiveSupport::MessageVerifier.new(Rails.application.config.secret_token).generate(data)
  end

  def decode_verifiable_msg(data)
    ActiveSupport::MessageVerifier.new(Rails.application.config.secret_token).verify(data)
  end
end
