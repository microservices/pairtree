Gem::Specification.new do |s|
  s.name             = %q{pairtree}
  s.summary          = %q{Ruby Pairtree implementation}
  s.version          = "0.1.0"
  s.homepage         = %q{http://github.com/microservices/pairtree}
  s.licenses         = ["Apache2"]
  s.rubygems_version = %q{1.3.7}

  s.authors          = ["Chris Beer"]
  s.date             = %q{2010-12-23}
  s.email            = %q{chris@cbeer.info}
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]


  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "rspec", ">= 2.0"
  s.add_development_dependency "rcov", ">= 0"
  s.add_development_dependency "yard"
  s.add_development_dependency "RedCloth"
end

