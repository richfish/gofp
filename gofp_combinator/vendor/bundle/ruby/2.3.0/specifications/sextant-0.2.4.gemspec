# -*- encoding: utf-8 -*-
# stub: sextant 0.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "sextant".freeze
  s.version = "0.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Richard Schneeman".freeze]
  s.date = "2013-06-14"
  s.description = "Sextant is a Rails engine that quickly shows the routes available".freeze
  s.email = ["richard.schneeman+rubygems@gmail.com".freeze]
  s.homepage = "https://github.com/schneems/sextant".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Sextant is a Rails engine that quickly shows the routes available.".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 3.2"])
      s.add_development_dependency(%q<capybara>.freeze, [">= 0.4.0"])
      s.add_development_dependency(%q<launchy>.freeze, ["~> 2.1.0"])
      s.add_development_dependency(%q<poltergeist>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 3.2"])
      s.add_dependency(%q<capybara>.freeze, [">= 0.4.0"])
      s.add_dependency(%q<launchy>.freeze, ["~> 2.1.0"])
      s.add_dependency(%q<poltergeist>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 3.2"])
    s.add_dependency(%q<capybara>.freeze, [">= 0.4.0"])
    s.add_dependency(%q<launchy>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<poltergeist>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
