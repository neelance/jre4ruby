Gem::Specification.new do |s|
  s.name = s.rubyforge_project = "jre4ruby"
  s.version = "1.0.1"
  s.files = ["jre4ruby.rb"] + Dir.glob("jre4ruby/lib/**/*.*") + Dir.glob("jre4ruby/fix/**/*.*") + Dir.glob("jre4ruby/rep/**/*.*")
  s.homepage = %q{http://github.com/neelance/jre4ruby/}
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["."]
  s.summary = "Converted Java Runtime Environment (JRE)."
end
