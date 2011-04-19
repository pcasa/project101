# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{best_in_place}
  s.version = "0.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bernat Farrero"]
  s.date = %q{2011-02-11}
  s.description = %q{BestInPlace is a jQuery script and a Rails 3 helper that provide the method best_in_place to display any object field easily editable for the user by just clicking on it. It supports input data, text data, boolean data and custom dropdown data. It works with RESTful controllers.}
  s.email = ["bernat@itnig.net"]
  s.homepage = %q{http://github.com/bernat/best_in_place}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{best_in_place}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{It makes any field in place editable by clicking on it, it works for inputs, textareas, select dropdowns and checkboxes}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0.0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
  end
end
