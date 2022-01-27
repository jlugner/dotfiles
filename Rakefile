require 'pathname'

CUSTOM_DESTINATIONS = {
}

def destination_for_file(file)
  return CUSTOM_DESTINATIONS[file] if CUSTOM_DESTINATIONS.has_key?(file)

  Pathname.new("$HOME/.#{file}")
end

task default: %w(sync)

task :symlinks do
  files = Dir.glob('files/**/*').filter_map do |file|
    next if Dir.exist?(file)

    pathname = Pathname.new(file)
    filename = pathname.relative_path_from('files')
    target_path = destination_for_file(filename.to_s)

    p filename.to_s

    [File.join(Pathname.pwd(), pathname), target_path] 
  end

  p files

  files.each do |file|
    system("ln \"#{file[0]}\" \"#{file[1]}\"")
  end
end

task sync: [:pull, :symlinks]

task :pull do
  system('git pull origin master')
end
