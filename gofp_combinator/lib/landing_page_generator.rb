class LandingPageGenerator
  attr_accessor :landing_page_name, :landing_page_id, :auth_name, :app_name, :backend_name

  LandingPageIdNameMapping = %w(
    tilt
    gigster
    abacus
    gocardless
    onelogin
    transferwise
    preact
    cozy
    invision
    coinbase
  )

  def initialize(landing_page_id, opts={})
    @landing_page_name = LandingPageIdNameMapping[landing_page_id.to_i - 1]
    @app_name = opts[:app_name].presence || opts["app_name"]
    @auth_name = opts[:auth_type].presence || opts["auth_type"].presence || "auth_1"
    @landing_page_id = landing_page_id.to_i
    backend_id = opts[:backend].presence || opts["backend"]
    @backend_name = BackendGenerator::BackendIdNameMapping[backend_id.to_i - 1]
  end

  def generate_landing_page!
    app_path = "/Users/richfisher/projects/garden_of_forking_paths/gofp_complete/#{@app_name}"

    Dir.chdir("/Users/richfisher/projects/garden_of_forking_paths/gofp_landing_pages") do
      `cp app/views/full_themes/full_theme_#{@landing_page_id}.haml #{app_path}/app/views/welcome/index.haml`
      `mkdir #{app_path}/app/assets/stylesheets/view_css`

      `cp app/assets/stylesheets/view_css/full_theme_#{@landing_page_id}.css.sass #{app_path}/app/assets/stylesheets/view_css/`
      `cp app/assets/javascripts/view_js/#{@landing_page_name}.js.coffee #{app_path}/app/assets/javascripts/view_js/`

      #footer?
      `cp app/assets/stylesheets/view_css/footer_#{@landing_page_name}.css.sass #{app_path}/app/assets/stylesheets/view_css/`
      `cp app/views/footers/_#{@landing_page_name}_footer.haml #{app_path}/app/views/layouts/_footer_welcome.haml`

      #slideout menu
      `cp app/assets/stylesheets/view_css/slideout_menu.css.sass #{app_path}/app/assets/stylesheets/view_css/`
      `cp app/views/slideout_menus/_default.haml #{app_path}/app/views/layouts/_slideout_menu.haml`

      #copy over stock images for theme
      Dir.foreach("app/assets/images") do |item|
        if !!item[@landing_page_name]
          `cp app/assets/images/#{item} #{app_path}/app/assets/images/`
        end
      end

      #Some seds to genericize heading/ footer etc inlines
      `sed -i -e 's:headers/#{@landing_page_name}_header:layouts/header_welcome:g' #{app_path}/app/views/welcome/index.haml`
      `sed -i -e 's:=render\ \"layouts/header_welcome\"::g' #{app_path}/app/views/layouts/welcome.haml`
      `sed -i -e 's:slideout_menus/default:layouts/slideout_menu:g' #{app_path}/app/views/welcome/index.haml`

      #copy landing page's buttons.css
      `cp app/assets/stylesheets/buttons.css.sass #{app_path}/app/assets/stylesheets/buttons.css.sass`

      #auth integration
      #assume devise unless otherwise noted
      `cp app/views/auth_pages/#{@auth_name}_signup_d.haml #{app_path}/app/views/users/registrations/new.haml`
      `cp app/views/auth_pages/#{@auth_name}_signup_d.haml #{app_path}/app/views/users/sessions/new.haml` #replace with login_d
      `rm #{app_path}/app/views/users/sessions/new.html.haml`
      `rm #{app_path}/app/views/users/registrations/new.html.haml`
      `cp app/assets/stylesheets/view_css/#{@auth_name}.css.sass #{app_path}/app/assets/stylesheets/view_css/`
      `cp app/assets/javascripts/view_js/#{@auth_name}.js.coffee #{app_path}/app/assets/javascripts/view_js/`
      `sed -i -e 's:\"#SignupLinkReplace\":signup_path:g' #{app_path}/app/views/welcome/index.haml`
      `sed -i -e 's:\"#LoginLinkReplace\":login_path:g' #{app_path}/app/views/welcome/index.haml`
      #make sure devise links are all there...

      #fix for footer_welcome for search (or other post landing page) sections
      `echo '.splash__footer\n\ \ .container\n\ \ \ \ background: transparent' >> #{app_path}/app/assets/stylesheets/view_css/footer_#{@landing_page_name}.css.sass`

      #copy in search preview feature
      `cp app/views/misc_glue_files/_search_previewer.haml #{app_path}/app/views/internal_pages/_search_previewer.haml`
      `echo '\n=render "internal_pages/search_previewer"' >> #{app_path}/app/views/welcome/index.haml`

      #possible onboarding integration
      if !!@backend_name["onboarding"]
        `echo '\n#toggleable_onboarding_preview=render "welcome/onboarding_cta"' >> #{app_path}/app/views/welcome/index.haml`
      end

    end

  end
end
