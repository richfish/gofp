class FrontendGenerator

  attr_accessor :app_name, :backend_name, :summary_card_name, :summary_card_id, :splash_page_name, :splash_page_id

  SummaryCardIdNameMapping = %w(
    traveldating
    codeinperson
    crafstmanave
    kickstarter
  )
  SplashPageIdNameMapping = %w(
    kickstarter
    buildzoom
    travelflings
    codeinperson
  )

  def initialize(summary_card_id, splash_page_id, opts={})
    @app_name = opts[:app_name].presence || opts["app_name"]
    backend_id = opts[:backend].presence || opts["backend"]
    @backend_name = BackendGenerator::BackendIdNameMapping[backend_id.to_i - 1]
    @summary_card_name = SummaryCardIdNameMapping[summary_card_id.to_i - 1]
    @splash_page_name = SplashPageIdNameMapping[splash_page_id.to_i - 1]
    @summary_card_id = summary_card_id.to_i
    @splash_page_id = splash_page_id.to_i
  end

  def generate_frontend!
    #allow keeping defaults (value 0)
    app_path = "/Users/richfisher/projects/garden_of_forking_paths/gofp_complete/#{@app_name}"

    Dir.chdir("/Users/richfisher/projects/garden_of_forking_paths/gofp_templates") do
      #summary cards
      unless @summary_card_id == 0
        `cp app/assets/stylesheets/view_css/summary_card_#{@summary_card_id}.css.sass #{app_path}/app/assets/stylesheets/view_css/`
        `cp app/views/templates/summary_cards_#{@summary_card_id}.haml #{app_path}/app/views/searchable_entities/_searchable_entity_summary_search.haml`
        `sed -i -e 's:\"#SplashPageLinkRemove\":searchable_entity_path(1):g' #{app_path}/app/views/searchable_entities/_searchable_entity_summary_search.haml`
      end

      #splash page
      unless @splash_page_id == 0
        `cp app/assets/stylesheets/view_css/splash_page_full_#{@splash_page_id}.css.sass #{app_path}/app/assets/stylesheets/view_css/`
        `cp app/views/templates/splash_page_full_#{@splash_page_id}.haml #{app_path}/app/views/searchable_entities/_searchable_entity_splash_page.haml`
        `cp app/assets/javascripts/view_js/photo_viewer.js.coffee #{app_path}/app/assets/javascripts/view_js/`
        `cp app/assets/stylesheets/view_css/photo_viewer.css.sass #{app_path}/app/assets/stylesheets/view_css/`
      end

      #copy in checkout and conversation etc preview
      #depending on backend type
      `cp app/views/misc_glue_files/_checkout_previewer.haml #{app_path}/app/views/internal_pages/_checkout_previewer.haml`
      `cp app/views/misc_glue_files/_conversation_previewer.haml #{app_path}/app/views/internal_pages/_conversation_previewer.haml`
      `echo '\n=render "internal_pages/checkout_previewer"' >> #{app_path}/app/views/searchable_entities/_searchable_entity_splash_page.haml`
      `echo '\n=render "internal_pages/conversation_previewer"' >> #{app_path}/app/views/searchable_entities/_searchable_entity_splash_page.haml`

    end
  end
end
