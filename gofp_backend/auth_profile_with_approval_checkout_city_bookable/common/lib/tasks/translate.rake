if Rails.env.development?
  namespace :translate do
    require 'google_translate'

    class GoogleTranslate
      #monkey patch a buggy method in gem google-translate
      def call_translate_service from_lang, to_lang, text
        url = translate_url(from_lang, to_lang)
        response = call_service url, text
        response.body.split(',').collect { |s| s == '' ? "\"\"" : s }.join(",").gsub(/\[,/,'[')
      end
    end

    @from ='en'
    @from_path = File.join("#{Rails.root}/config/locales")
    @to = 'es'
    @to_path = File.join("#{Rails.root}/config/locales/#{@to}")

    def deep_join(from, to)
      from.each do |k,v|
        if to[k]
          if v.is_a?(String) || v.is_a?(NilClass)
            #do nothing
          elsif v.is_a?(Hash)
            new_to_hash = {}
            v.keys.each do |v_k|
              new_to_hash[v_k] = to[k][v_k]
            end
            to[k] = new_to_hash
            deep_join(from[k], to[k])
          else
            raise 'dont know how to handle: '+v.class
          end
        else
          if v.is_a?(String)
            str = v
            params = str.scan(Regexp.new('%{(.*?)}')).flatten
            params.each do |x|
              str.gsub!(Regexp.new("%{#{x}}"), "PARAM_#{x.upcase}_PARAM")
            end

            begin
              puts "calling #{@from}->#{@to}: #{k}='#{str}'"
              translate_result = GoogleTranslate.new.translate(@from, @to, str)
              to_v = translate_result[0].map{|x| x[0]}.join(' ').strip
              params.each do |x|
                to_v.gsub!(Regexp.new("PARAM_#{x.upcase}_PARAM"), "%{#{x}}")
              end

              to[k] = to_v
              puts "results: #{v}-------> #{to_v}"
            rescue => e
              to[k] = e.message
            end
          elsif v.is_a?(Hash)
            to[k] = {}
            deep_join(from[k], to[k])
          elsif v.is_a?(NilClass)
            to[k] = ''
          else
            raise 'dont know how to handle: '+v.class.name
          end
        end
      end
    end

    def translate_file(from_file, to_file)
      yml_from = YAML::load_file(from_file)
      if File.exists? to_file
        yml_to = YAML::load_file(to_file) || {}
      else
        yml_to = {}
      end
      yml_to = {@to => {}}.merge(yml_to)
      deep_join(yml_from[@from], yml_to[@to])
      File.open(to_file, 'w+') {|f| f.write YAML::dump(yml_to) }
    end

    def translate_dir(path)
      unless Dir.exists?(@to_path)
        Dir.mkdir(@to_path)
      end

      Dir.foreach(path) do |entry|
        next if (entry == '..' || entry == '.')
        full_path = File.join(path, entry)
        puts full_path
        if File.directory?(full_path)
          if File.basename(full_path) == @from ||full_path =~ Regexp.new("\\/#{@from}\\/")
            translate_dir(full_path)
          end
        elsif File.basename(full_path) =~ /(.*?)\.(.+?)\.yml/
          if $2 == @from
            to_file = File.join(File.dirname(full_path), "#{$1}.#{@to}.yml")
            translate_file(full_path, to_file)
          end
        else
          to_file = File.join(@to_path, entry)
          translate_file(full_path, to_file)
        end
      end
    end

    task :spanish => :environment do
      translate_dir("#{Rails.root}/config/locales")
    end
  end
end



