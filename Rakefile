#require 'zbspec/rake_task'

#task :default => [:check, :zbspec]

desc "Install dependencies"
task :setup do
  sh "brew bundle"
  sh "luarocks install luacheck"
end

desc "Run static analysis (luacheck)"
task :check do
  sh "luacheck 42.13/media/lua/"
end

desc "update steam.txt with info from info.yml"
task :info do
  require 'yaml'
  info = YAML.load_file('info.yml')
  in_lines = File.readlines('steam.txt')

  out_lines = []
  i = 0
  while i < in_lines.size
    line = in_lines[i]
    out_lines << line

    if line =~ /^\[h1\]Integrations/
      out_lines << "[list]\n"
      info['mods'].sort_by{ |id,name| id < 0 ? "zzz" : name.downcase }.each do |id, name|
        if id > 0
          comment = name[/ \(.+\)$/]
          name = name.sub(comment, "") if comment
          out_lines << "   [*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=#{id}]#{name}[/url]#{comment}\n"
        else
          out_lines << "   [*]#{name}\n"
        end
      end
      out_lines << "[/list]\n"
      out_lines << "\n"

      i += 1 while in_lines[i].strip != ""
    end

    i += 1
  end

  File.write('steam.txt', out_lines.join)
end

#ZBSpec::RakeTask.new
