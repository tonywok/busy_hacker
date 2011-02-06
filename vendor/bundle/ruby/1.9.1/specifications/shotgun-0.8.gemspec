# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shotgun}
  s.version = "0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Tomayko"]
  s.date = %q{2010-06-23}
  s.default_executable = %q{shotgun}
  s.description = %q{reloading rack development server}
  s.email = %q{rtomayko@gmail.com}
  s.executables = ["shotgun"]
  s.extra_rdoc_files = ["README"]
  s.files = ["COPYING", "README", "Rakefile", "bin/shotgun", "lib/shotgun.rb", "lib/shotgun/favicon.rb", "lib/shotgun/loader.rb", "lib/shotgun/static.rb", "man/index.txt", "man/shotgun.1", "man/shotgun.1.ronn", "shotgun.gemspec", "test/big.ru", "test/boom.ru", "test/slow.ru", "test/test-sinatra.ru", "test/test.ru", "test/test_shotgun_loader.rb", "test/test_shotgun_static.rb"]
  s.homepage = %q{http://rtomayko.github.com/shotgun/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{reloading rack development server}
  s.test_files = ["test/test_shotgun_loader.rb", "test/test_shotgun_static.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0"])
    else
      s.add_dependency(%q<rack>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0"])
  end
end
