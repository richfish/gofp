class WelcomeController < ApplicationController
  def index
  end

  def generate_app
    opts = {
      app_name: params[:app_name],
      backend: params[:combinator_selected_backend],
      summary_card: params[:combinator_selected_summary_card],
      splash_page: params[:combinator_selected_splash_page],
      landing_page: params[:combinator_selected_landing],
      auth_type: params[:combinator_selected_auth]
    }
    AppGeneratorJob.perform_async(params[:combinator_selected_backend], opts)

    flash[:notice] = "Ok, we're generating your app with sidekiq - this might take like 8 minutes"
    redirect_to root_path
  end
end
