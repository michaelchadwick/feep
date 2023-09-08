require "bundler/gem_tasks"

Dir.glob('tasks/**/*.rake').each(&method(:import))

task :deploy do |t|
  sh "git push origin master"
  sh "rake build"

  file = Dir.glob("pkg/*").max_by {|f| File.mtime(f)}

  sh "gem push #{file}"
end
