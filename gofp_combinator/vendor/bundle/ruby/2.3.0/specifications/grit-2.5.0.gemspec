# -*- encoding: utf-8 -*-
# stub: grit 2.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "grit".freeze
  s.version = "2.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tom Preston-Werner".freeze, "Scott Chacon".freeze]
  s.date = "2012-04-22"
  s.description = "Grit is a Ruby library for extracting information from a git repository in an object oriented manner.".freeze
  s.email = "tom@github.com".freeze
  s.extra_rdoc_files = ["README.md".freeze, "LICENSE".freeze]
  s.files = ["LICENSE".freeze, "README.md".freeze]
  s.homepage = "http://github.com/mojombo/grit".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubyforge_project = "grit".freeze
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Ruby Git bindings.".freeze

  s.installed_by_version = "2.6.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<posix-spawn>.freeze, ["~> 0.3.6"])
      s.add_runtime_dependency(%q<mime-types>.freeze, ["~> 1.15"])
      s.add_runtime_dependency(%q<diff-lcs>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    else
      s.add_dependency(%q<posix-spawn>.freeze, ["~> 0.3.6"])
      s.add_dependency(%q<mime-types>.freeze, ["~> 1.15"])
      s.add_dependency(%q<diff-lcs>.freeze, ["~> 1.1"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<posix-spawn>.freeze, ["~> 0.3.6"])
    s.add_dependency(%q<mime-types>.freeze, ["~> 1.15"])
    s.add_dependency(%q<diff-lcs>.freeze, ["~> 1.1"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
  end
end
