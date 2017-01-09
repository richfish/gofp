if Rails.env.production? || Rails.env.staging? || Rails.env.demo? || Rails.env.sandbox? || Rails.env.development?
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = "#{Rails.root.to_s}/config/aws.yml"
  Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
  Paperclip::Attachment.default_options[:path] = ":class/:attachment/:id_partition/:style/:filename"
  Paperclip::Attachment.default_options[:s3_host_name] = "s3-us-west-2.amazonaws.com"
elsif Rails.env.test?
  Paperclip::Attachment.default_options[:url] = "/system/:attachment/:id/:style/:basename.:extension"
  Paperclip::Attachment.default_options[:path] = ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
else
  raise "Unknown environment when setting up paperclip: #{Rails.env}"
end


