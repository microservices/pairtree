Gem::Specification.new do |s|
  s.name             = %q{pairtree}
  s.summary          = %q{Ruby Pairtree implementation}
  s.version          = "0.2.0"
  s.homepage         = %q{http://github.com/mlibrary/pairtree}
  s.licenses         = ["Apache2"]
  s.authors          = ["Chris Beer, Bryan Hockey, Michael Slone"]
  s.date             = %q{2015-05-05}
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]


  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec", ">= 2.0"
  s.add_development_dependency "yard"
  s.add_development_dependency "rake"
end

