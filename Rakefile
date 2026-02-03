task :default => [:check, :spec]

task :check do
  sh "luacheck 42.13/media/lua/"
end

task :spec do
  sh "zbspec"
end
