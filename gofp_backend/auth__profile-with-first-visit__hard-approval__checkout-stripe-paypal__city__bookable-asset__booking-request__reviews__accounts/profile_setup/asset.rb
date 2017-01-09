class Asset < ActiveRecord::Base

  has_attached_file :image,
                      :styles => { :medium => "300x350!", :small => "200x235!", :thumb => "100x118>", :tiny => "18x20!" },
                      :default_url => "missing2.png",
                      :s3_protocol => (Rails.env.development? || Rails.env.test?) ? :http : :https

  belongs_to :owner, :polymorphic => true

  validates_attachment :image, :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] }
  #validates_attachment_content_type :file, :content_type => /\Aimage/

  #process_in_background :image, if: Proc.new{ |instance| instance.image? }, :processing_image_url => "/assets/wait_wheel.gif"

  # def content_from_url=(url)
  #   self.original_url = url
  #   self.file = URI.parse(url)
  # end

  def image?
    ["image/jpeg", "image/jpg", "image/png", "image/gif", "image/bmp", "image/tif", "image/tiff"].include?(file_content_type)
  end



end