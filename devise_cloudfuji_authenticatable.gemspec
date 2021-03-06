# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_cloudfuji_authenticatable/version"

Gem::Specification.new do |s|
  s.name        = "devise_cloudfuji_authenticatable"
  s.version     = DeviseCloudfujiAuthenticatable::VERSION
  s.authors     = ["Sean Grove", "Didier Lafforgue"]
  s.email       = "s@bushi.do"
  s.homepage    = "http://github.com/cloudfuji/devise_cloudfuji_authenticatable"
  s.summary     = %q{Cloudfuji SSO authentication module for Devise}
  s.description = %q{Cloudfuji SSO authentication module for Devise. A slight variant of the excellent work from Nat Budlin on devise_cas_authenticatable.}

  s.rubyforge_project = "devise_cloudfuji_authenticatable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency(%q<devise>, ["= 1.5.3"])
  s.add_runtime_dependency(%q<rubycas-client>, [">= 2.2.1"])

  s.add_development_dependency("rspec")
  s.add_development_dependency("mocha")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("sqlite3-ruby")
  s.add_development_dependency("sham_rack")
  s.add_development_dependency("capybara")
  s.add_development_dependency('crypt-isaac')
  s.add_development_dependency('launchy')
  s.add_development_dependency('pry')
end
