# -*- encoding: utf-8 -*-
# stub: git-up 0.5.12 ruby lib

Gem::Specification.new do |s|
  s.name = "git-up".freeze
  s.version = "0.5.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aanand Prasad".freeze, "Elliot Crosby-McCullough".freeze, "Adrian Irving-Beer".freeze, "Joshua Wehner".freeze]
  s.date = "2013-07-23"
  s.email = ["aanand.prasad@gmail.com".freeze, "elliot.cm@gmail.com".freeze]
  s.executables = ["git-up".freeze]
  s.files = ["bin/git-up".freeze]
  s.homepage = "http://github.com/aanand/git-up".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "git command to fetch and rebase all branches".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<colored>.freeze, [">= 1.2"])
      s.add_runtime_dependency(%q<grit>.freeze, [">= 0"])
    else
      s.add_dependency(%q<colored>.freeze, [">= 1.2"])
      s.add_dependency(%q<grit>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<colored>.freeze, [">= 1.2"])
    s.add_dependency(%q<grit>.freeze, [">= 0"])
  end
end
