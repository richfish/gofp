# -*- encoding: utf-8 -*-
# stub: resource_accessor 1.2.6 ruby lib

Gem::Specification.new do |s|
  s.name = "resource_accessor".freeze
  s.version = "1.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alexander Shvets".freeze]
  s.date = "2016-07-07"
  s.description = "This library is used to simplify access to protected or unprotected http resource.".freeze
  s.email = "alexander.shvets@gmail.com".freeze
  s.homepage = "http://github.com/shvets/resource_accessor".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "This library is used to simplify access to protected or unprotected http resource".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gemspec_deps_gen>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<gemcutter>.freeze, ["~> 0.7"])
      s.add_development_dependency(%q<thor>.freeze, ["~> 0.19"])
    else
      s.add_dependency(%q<gemspec_deps_gen>.freeze, ["~> 1.1"])
      s.add_dependency(%q<gemcutter>.freeze, ["~> 0.7"])
      s.add_dependency(%q<thor>.freeze, ["~> 0.19"])
    end
  else
    s.add_dependency(%q<gemspec_deps_gen>.freeze, ["~> 1.1"])
    s.add_dependency(%q<gemcutter>.freeze, ["~> 0.7"])
    s.add_dependency(%q<thor>.freeze, ["~> 0.19"])
  end
end
