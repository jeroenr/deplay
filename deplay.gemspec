require 'rake'

Gem::Specification.new do |s|
  s.name = "deplay"
  s.summary = "Deploying play applications with capistrano"
  s.description = "See http://jeroenr.github.com/deplay/"
  s.version = "1.0.0"
  s.authors = ["Jeroen Rosenberg","Egemen Kalyoncu"]
  s.email = ["jeroen.rosenberg@gmail.com"]
  s.homepage = "http://github.com/jeroenr/deplay"
  s.files = FileList["README.md", "Rakefile", "lib/*.rb"]

  s.add_dependency "capistrano", ">= 2.5.21"
end
