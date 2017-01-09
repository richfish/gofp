class BackendGenerator

  attr_accessor :backend_name, :app_name, :asset_name

  BackendIdNameMapping = %w(
    auth__dashboard-vertical-app-bar__search-with-splash__profile__conversations__soft-approval__checkout-subscription-stripe-paypal
    auth__onboarding-flow__dashboard-vertical-app-bar__search-with-splash__profile__conversations__soft-approval__checkout-subscription-stripe-paypal
    auth__profile-with-first-visit__hard-approval__checkout-stripe-paypal__city__bookable-asset__booking-request__reviews__accounts
    auth__onboarding-flow__dashboard-vertical-app-bar__search-with-splash__map-view__profile__conversations__soft-approval__checkout-subscription-stripe-paypal
    auth_dashboard_checkout_subscription_stripe_paypal
    single_page_most_basic
  )

  def initialize(backend_id, opts={})
    @backend_name = BackendIdNameMapping[backend_id.to_i - 1]
    @app_name = opts[:app_name].presence || opts["app_name"]
    @asset_name = opts[:asset_name].presence || opts["asset_name"]
  end

  def generate_backend!
    #use exec to see output
    Dir.chdir("/Users/richfisher/projects/garden_of_forking_paths/gofp_backend/#{@backend_name}") do
      `rails new #{@app_name} --skip-bundle`
      #`rm #{@app_name}/Gemfile.lock; echo > #{@app_name}/Gemfile.lock`
      `sh setup.sh #{@app_name}`
      `mv #{@app_name} /Users/richfisher/projects/garden_of_forking_paths/gofp_complete/`
    end
  end
end
