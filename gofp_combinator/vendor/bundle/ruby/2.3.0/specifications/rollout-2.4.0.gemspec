# -*- encoding: utf-8 -*-
# stub: rollout 2.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rollout".freeze
  s.version = "2.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["James Golick".freeze]
  s.date = "2016-10-28"
  s.description = "Feature flippers with redis.".freeze
  s.email = ["jamesgolick@gmail.com".freeze]
  s.homepage = "https://github.com/FetLife/rollout".freeze
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Feature flippers with redis.".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_development_dependency(%q<redis>.freeze, [">= 0"])
      s.add_development_dependency(%q<fakeredis>.freeze, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
      s.add_dependency(%q<redis>.freeze, [">= 0"])
      s.add_dependency(%q<fakeredis>.freeze, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.0.0"])
    s.add_dependency(%q<redis>.freeze, [">= 0"])
    s.add_dependency(%q<fakeredis>.freeze, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
  end
end
