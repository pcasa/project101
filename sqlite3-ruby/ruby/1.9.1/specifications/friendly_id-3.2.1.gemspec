# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{friendly_id}
  s.version = "3.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Norman Clarke", "Adrian Mugnolo", "Emilio Tagua"]
  s.date = %q{2011-02-02}
  s.description = %q{    FriendlyId is the "Swiss Army bulldozer" of slugging and permalink plugins
    for Ruby on Rails. It allows you to create pretty URL's and work with
    human-friendly strings as if they were numeric ids for ActiveRecord models.
}
  s.email = ["norman@njclarke.com", "adrian@mugnolo.com", "miloops@gmail.com"]
  s.files = ["test/active_record_adapter/basic_slugged_model_test.rb", "test/active_record_adapter/cached_slug_test.rb", "test/active_record_adapter/custom_normalizer_test.rb", "test/active_record_adapter/custom_table_name_test.rb", "test/active_record_adapter/default_scope_test.rb", "test/active_record_adapter/optimistic_locking_test.rb", "test/active_record_adapter/scoped_model_test.rb", "test/active_record_adapter/simple_test.rb", "test/active_record_adapter/slug_test.rb", "test/active_record_adapter/slugged_status_test.rb", "test/active_record_adapter/sti_test.rb", "test/active_record_adapter/tasks_test.rb", "test/friendly_id_test.rb"]
  s.homepage = %q{http://norman.github.com/friendly_id}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{friendly-id}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A comprehensive slugging and pretty-URL plugin.}
  s.test_files = ["test/active_record_adapter/basic_slugged_model_test.rb", "test/active_record_adapter/cached_slug_test.rb", "test/active_record_adapter/custom_normalizer_test.rb", "test/active_record_adapter/custom_table_name_test.rb", "test/active_record_adapter/default_scope_test.rb", "test/active_record_adapter/optimistic_locking_test.rb", "test/active_record_adapter/scoped_model_test.rb", "test/active_record_adapter/simple_test.rb", "test/active_record_adapter/slug_test.rb", "test/active_record_adapter/slugged_status_test.rb", "test/active_record_adapter/sti_test.rb", "test/active_record_adapter/tasks_test.rb", "test/friendly_id_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<babosa>, ["~> 0.2.1"])
      s.add_development_dependency(%q<activerecord>, ["~> 3.0.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9"])
      s.add_development_dependency(%q<sqlite3-ruby>, ["~> 1"])
    else
      s.add_dependency(%q<babosa>, ["~> 0.2.1"])
      s.add_dependency(%q<activerecord>, ["~> 3.0.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9"])
      s.add_dependency(%q<sqlite3-ruby>, ["~> 1"])
    end
  else
    s.add_dependency(%q<babosa>, ["~> 0.2.1"])
    s.add_dependency(%q<activerecord>, ["~> 3.0.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9"])
    s.add_dependency(%q<sqlite3-ruby>, ["~> 1"])
  end
end
