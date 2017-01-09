# -*- encoding: utf-8 -*-
# stub: poltergeist 1.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "poltergeist".freeze
  s.version = "1.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jon Leighton".freeze]
  s.date = "2014-05-30"
  s.description = "Poltergeist is a driver for Capybara that allows you to run your tests on a headless WebKit browser, provided by PhantomJS.".freeze
  s.email = ["j@jonathanleighton.com".freeze]
  s.homepage = "http://github.com/jonleighton/poltergeist".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.8".freeze
  s.summary = "PhantomJS driver for Capybara".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>.freeze, ["~> 2.1"])
      s.add_runtime_dependency(%q<websocket-driver>.freeze, [">= 0.2.0"])
      s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<cliver>.freeze, ["~> 0.3.1"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.12"])
      s.add_development_dependency(%q<sinatra>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<image_size>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<pdf-reader>.freeze, ["~> 1.3.3"])
      s.add_development_dependency(%q<coffee-script>.freeze, ["~> 2.2.0"])
      s.add_development_dependency(%q<guard-coffeescript>.freeze, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec-rerun>.freeze, ["~> 0.1"])
    else
      s.add_dependency(%q<capybara>.freeze, ["~> 2.1"])
      s.add_dependency(%q<websocket-driver>.freeze, [">= 0.2.0"])
      s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
      s.add_dependency(%q<cliver>.freeze, ["~> 0.3.1"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.12"])
      s.add_dependency(%q<sinatra>.freeze, ["~> 1.0"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<image_size>.freeze, ["~> 1.0"])
      s.add_dependency(%q<pdf-reader>.freeze, ["~> 1.3.3"])
      s.add_dependency(%q<coffee-script>.freeze, ["~> 2.2.0"])
      s.add_dependency(%q<guard-coffeescript>.freeze, ["~> 1.0.0"])
      s.add_dependency(%q<rspec-rerun>.freeze, ["~> 0.1"])
    end
  else
    s.add_dependency(%q<capybara>.freeze, ["~> 2.1"])
    s.add_dependency(%q<websocket-driver>.freeze, [">= 0.2.0"])
    s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
    s.add_dependency(%q<cliver>.freeze, ["~> 0.3.1"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.12"])
    s.add_dependency(%q<sinatra>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<image_size>.freeze, ["~> 1.0"])
    s.add_dependency(%q<pdf-reader>.freeze, ["~> 1.3.3"])
    s.add_dependency(%q<coffee-script>.freeze, ["~> 2.2.0"])
    s.add_dependency(%q<guard-coffeescript>.freeze, ["~> 1.0.0"])
    s.add_dependency(%q<rspec-rerun>.freeze, ["~> 0.1"])
  end
end
