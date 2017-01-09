# -*- encoding: utf-8 -*-
# stub: google-translate 1.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "google-translate".freeze
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alexander Shvets".freeze]
  s.date = "2014-12-19"
  s.description = "Simple client for Google Translate API.".freeze
  s.email = "alexander.shvets@gmail.com".freeze
  s.executables = ["translate".freeze, "t".freeze]
  s.files = ["bin/t".freeze, "bin/translate".freeze]
  s.homepage = "http://github.com/shvets/google-translate".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Summary: Simple client for Google Translate API.".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>.freeze, ["~> 1.8"])
      s.add_runtime_dependency(%q<resource_accessor>.freeze, ["~> 1.2"])
      s.add_runtime_dependency(%q<thor>.freeze, ["~> 0.19"])
      s.add_development_dependency(%q<gemspec_deps_gen>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<gemcutter>.freeze, ["~> 0.7"])
    else
      s.add_dependency(%q<json_pure>.freeze, ["~> 1.8"])
      s.add_dependency(%q<resource_accessor>.freeze, ["~> 1.2"])
      s.add_dependency(%q<thor>.freeze, ["~> 0.19"])
      s.add_dependency(%q<gemspec_deps_gen>.freeze, ["~> 1.1"])
      s.add_dependency(%q<gemcutter>.freeze, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<json_pure>.freeze, ["~> 1.8"])
    s.add_dependency(%q<resource_accessor>.freeze, ["~> 1.2"])
    s.add_dependency(%q<thor>.freeze, ["~> 0.19"])
    s.add_dependency(%q<gemspec_deps_gen>.freeze, ["~> 1.1"])
    s.add_dependency(%q<gemcutter>.freeze, ["~> 0.7"])
  end
end
