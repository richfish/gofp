# -*- encoding: utf-8 -*-
# stub: guard-spork 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "guard-spork".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Thibaud Guillaume-Gentil".freeze]
  s.date = "2014-12-12"
  s.description = "Guard::Spork automatically manage Spork DRb servers.".freeze
  s.email = ["thibaud@thibaud.me".freeze]
  s.homepage = "http://rubygems.org/gems/guard-spork".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubyforge_project = "guard-spork".freeze
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Guard gem for Spork".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>.freeze, ["~> 2.0"])
      s.add_runtime_dependency(%q<guard-compat>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<spork>.freeze, [">= 0.8.4"])
      s.add_runtime_dependency(%q<childprocess>.freeze, [">= 0.2.3"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1"])
      s.add_development_dependency(%q<transpec>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>.freeze, ["~> 4.4"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.9.12.6"])
    else
      s.add_dependency(%q<guard>.freeze, ["~> 2.0"])
      s.add_dependency(%q<guard-compat>.freeze, ["~> 1.0"])
      s.add_dependency(%q<spork>.freeze, [">= 0.8.4"])
      s.add_dependency(%q<childprocess>.freeze, [">= 0.2.3"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
      s.add_dependency(%q<transpec>.freeze, [">= 0"])
      s.add_dependency(%q<guard-rspec>.freeze, ["~> 4.4"])
      s.add_dependency(%q<pry>.freeze, ["~> 0.9.12.6"])
    end
  else
    s.add_dependency(%q<guard>.freeze, ["~> 2.0"])
    s.add_dependency(%q<guard-compat>.freeze, ["~> 1.0"])
    s.add_dependency(%q<spork>.freeze, [">= 0.8.4"])
    s.add_dependency(%q<childprocess>.freeze, [">= 0.2.3"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
    s.add_dependency(%q<transpec>.freeze, [">= 0"])
    s.add_dependency(%q<guard-rspec>.freeze, ["~> 4.4"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.9.12.6"])
  end
end
