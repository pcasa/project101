# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails3_acts_as_paranoid}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.7") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gonçalo Silva"]
  s.date = %q{2010-12-26}
  s.description = %q{Active Record (>=3.0) plugin which allows you to hide and restore records without actually deleting them. Check its GitHub page for more in-depth information.}
  s.email = ["goncalossilva@gmail.com"]
  s.homepage = %q{http://github.com/goncalossilva/rails3_acts_as_paranoid}
  s.require_paths = ["lib", "lib/validations"]
  s.rubyforge_project = %q{rails3_acts_as_paranoid}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Active Record (>=3.0) plugin which allows you to hide and restore records without actually deleting them.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0"])
  end
end
