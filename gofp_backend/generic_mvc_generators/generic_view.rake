#generates real simple view with all the basic attribtues + bootstrap

task :generic_view, [:model_name] => [:environment] do |t, args|

  model_name     = args[:model_name].capitalize.to_s
  model_singular = model_name.downcase
  model_plural   = model_name.downcase.pluralize
  attributes     = Object.const_get("#{model_name}").column_names - [:id, :created_at, :updated_at, :status].map(&:to_s)
  attributes     = attributes.reject{|x| x['_id'] || x['_key']}


  unless Dir.exists? "app/views/#{model_plural}"
    Dir.mkdir "app/views/#{model_plural}"
  end
  File.open("app/views/#{model_plural}/_basic_show_view.haml", "w") do |f|
    f.puts ".#{model_singular}"
    attributes.each do |attr|
      f.puts <<-END
  .row
    .col-sm-12
      %h4 #{attr.to_s.split('_').map(&:capitalize).join(' ')}
      =@#{model_singular}.#{attr}
      END
    end
  end

end
