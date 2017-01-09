# -*- encoding: utf-8 -*-
# stub: spork-rails 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "spork-rails".freeze
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tim Harper".freeze, "Sahil Muthoo".freeze]
  s.date = "2013-09-14"
  s.description = "Plugin for Spork to support Rails.".freeze
  s.email = ["timcharper+spork@gmail.com".freeze, "sahil.muthoo@gmail.com".freeze]
  s.extra_rdoc_files = ["MIT-LICENSE".freeze, "README.rdoc".freeze]
  s.files = ["MIT-LICENSE".freeze, "README.rdoc".freeze]
  s.homepage = "http://github.com/sporkrb/spork-rails".freeze
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubyforge_project = "spork".freeze
  s.rubygems_version = "2.6.8".freeze
  s.summary = "spork".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spork>.freeze, [">= 1.0rc0"])
      s.add_runtime_dependency(%q<rails>.freeze, ["< 5", ">= 3.0.0"])
    else
      s.add_dependency(%q<spork>.freeze, [">= 1.0rc0"])
      s.add_dependency(%q<rails>.freeze, ["< 5", ">= 3.0.0"])
    end
  else
    s.add_dependency(%q<spork>.freeze, [">= 1.0rc0"])
    s.add_dependency(%q<rails>.freeze, ["< 5", ">= 3.0.0"])
  end
end
