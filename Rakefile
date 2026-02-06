task :default => [:check, :spec]

desc "Install dependencies"
task :setup do
  sh "brew bundle"
  sh "luarocks install luacheck"
end

desc "Run static analysis (luacheck)"
task :check do
  sh "luacheck 42.13/media/lua/"
end

desc "Run ZBSpec tests"
task :spec do
  sh "zbspec"
end
