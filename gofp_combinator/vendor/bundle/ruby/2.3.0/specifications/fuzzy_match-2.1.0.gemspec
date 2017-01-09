# -*- encoding: utf-8 -*-
# stub: fuzzy_match 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "fuzzy_match".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Seamus Abshere".freeze]
  s.date = "2014-07-14"
  s.description = "Find a needle in a haystack using string similarity and (optionally) regexp rules. Replaces loose_tight_dictionary.".freeze
  s.email = ["seamus@abshere.net".freeze]
  s.executables = ["fuzzy_match".freeze]
  s.files = ["bin/fuzzy_match".freeze]
  s.homepage = "https://github.com/seamusabshere/fuzzy_match".freeze
  s.rubyforge_project = "fuzzy_match".freeze
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Find a needle in a haystack using string similarity and (optionally) regexp rules. Replaces loose_tight_dictionary.".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<active_record_inline_schema>.freeze, [">= 0.4.0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-core>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-expectations>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec-mocks>.freeze, [">= 0"])
      s.add_development_dependency(%q<activerecord>.freeze, [">= 3"])
      s.add_development_dependency(%q<mysql2>.freeze, [">= 0"])
      s.add_development_dependency(%q<cohort_analysis>.freeze, [">= 0"])
      s.add_development_dependency(%q<weighted_average>.freeze, [">= 0"])
      s.add_development_dependency(%q<yard>.freeze, [">= 0"])
      s.add_development_dependency(%q<amatch>.freeze, [">= 0"])
    else
      s.add_dependency(%q<active_record_inline_schema>.freeze, [">= 0.4.0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-core>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-expectations>.freeze, [">= 0"])
      s.add_dependency(%q<rspec-mocks>.freeze, [">= 0"])
      s.add_dependency(%q<activerecord>.freeze, [">= 3"])
      s.add_dependency(%q<mysql2>.freeze, [">= 0"])
      s.add_dependency(%q<cohort_analysis>.freeze, [">= 0"])
      s.add_dependency(%q<weighted_average>.freeze, [">= 0"])
      s.add_dependency(%q<yard>.freeze, [">= 0"])
      s.add_dependency(%q<amatch>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<active_record_inline_schema>.freeze, [">= 0.4.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-core>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-expectations>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-mocks>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 3"])
    s.add_dependency(%q<mysql2>.freeze, [">= 0"])
    s.add_dependency(%q<cohort_analysis>.freeze, [">= 0"])
    s.add_dependency(%q<weighted_average>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
    s.add_dependency(%q<amatch>.freeze, [">= 0"])
  end
end
