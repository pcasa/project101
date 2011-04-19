# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jquery-rails}
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["André Arko"]
  s.date = %q{2011-02-05}
  s.description = %q{This gem provides a Rails generator to install jQuery and the jQuery-ujs driver into your Rails 3 application, and then have them included automatically instead of Prototype.}
  s.email = ["andre@arko.net"]
  s.homepage = %q{http://rubygems.org/gems/jquery-rails}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jquery-rails}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Use jQuery with Rails 3}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.14.4"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
      s.add_development_dependency(%q<webmock>, ["~> 1.4.0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<thor>, ["~> 0.14.4"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
      s.add_dependency(%q<webmock>, ["~> 1.4.0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<thor>, ["~> 0.14.4"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
    s.add_dependency(%q<webmock>, ["~> 1.4.0"])
  end
end
