require  "sidekiq/web"

Rails.application.routes.draw do

  root "welcome#index"

  get 'color_palette' => 'internal_pages#color_palette'
  get 'color_palette_md' => 'internal_pages#color_palette_md'


  get 'carousel_1' => "splashes#carousel_1"
  get 'gradient_img_1' => "splashes#gradient_img_1"
  get 'screenshot_gradient_1' => "splashes#screenshot_gradient_1"
  get 'video_1' => "splashes#video_1"

  get 'how_works_1' => "how_works#how_works_1"
  get 'how_works_2' => "how_works#how_works_2"

  get 'icon_sets_1' => 'icon_sets#icon_sets_1'
  get 'icon_sets_2' => 'icon_sets#icon_sets_2'

  get 'full_theme_1' => 'full_themes#full_theme_1'
  get 'full_theme_2' => 'full_themes#full_theme_2'
  get 'full_theme_3' => 'full_themes#full_theme_3'
  get 'full_theme_4' => 'full_themes#full_theme_4'
  get 'full_theme_5' => 'full_themes#full_theme_5'
  get 'full_theme_6' => 'full_themes#full_theme_6'
  get 'full_theme_7' => 'full_themes#full_theme_7'
  get 'full_theme_8' => 'full_themes#full_theme_8'
  get 'full_theme_9' => 'full_themes#full_theme_9'
  get 'full_theme_10' => 'full_themes#full_theme_10'
  get 'full_theme_11' => 'full_themes#full_theme_11'

  get 'auth_1' => 'auth_pages#auth_1'
  get 'auth_2' => 'auth_pages#auth_2'

  mount Sidekiq::Web, at: "/sidekiq"
end
