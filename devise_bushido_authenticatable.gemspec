# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{devise_bushido_authenticatable}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Akash Manohar J", "Sean Grove", "Didier Lafforgue"]
  s.date = %q{2011-09-06}
  s.description = %q{Bushido SSO authentication module for Devise. A slight variant of the excellent work from Nat Budlin on devise_cas_authenticatable.}
  s.email = %q{s@bushi.do}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = `git ls-files`.split("\n")
  s.homepage = %q{http://github.com/bushido/bushido_cas_authenticatable}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Bushido SSO authentication module for Devise}

  s.add_runtime_dependency(%q<devise>, [">= 1.0.6"])
  s.add_runtime_dependency(%q<rubycas-client>, [">= 2.2.1"])
    
  s.add_development_dependency("rails", ">= 3.0.7")
  s.add_development_dependency("rspec-rails", ">= 2.6.1")
  s.add_development_dependency("mocha")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("sqlite3-ruby")
  s.add_development_dependency("sham_rack")
  s.add_development_dependency("capybara")
  s.add_development_dependency('crypt-isaac')
  s.add_development_dependency('launchy')
end

