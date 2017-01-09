class AppGeneratorJob
  include Sidekiq::Worker

  def perform(backend_id, opts={})
    BackendGenerator.new(backend_id, opts).generate_backend!

    puts "--------------- Backend Complete ---------------"

    LandingPageGenerator.new(opts["landing_page"], opts).generate_landing_page!

    puts "--------------- Landing Page Complete ---------------"

    FrontendGenerator.new(opts["summary_card"], opts["splash_page"], opts).generate_frontend!

    puts "--------------- Frontend Templates Complete ---------------"

    puts "--------------- Checking into Git ---------------"

    app_name = opts[:app_name].presence || opts["app_name"]
    Dir.chdir("/Users/richfisher/projects/garden_of_forking_paths/gofp_complete/#{app_name}") do
      `git add .`
      `git commit -m "completed full AppGeneratorJob"`
    end
  end
end
