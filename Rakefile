# frozen_string_literal: true

CUSTOM_DESTINATIONS = {}.freeze

def find_file_target(file)
  return CUSTOM_DESTINATIONS[file] if CUSTOM_DESTINATIONS.key?(file)

  File.expand_path("~/.#{file}")
end

task default: %w[sync]

task :symlinks do
  files = Dir.glob('files/**/*').filter_map do |file|
    next if File.directory?(file)

    filename = File.basename(file)
    target_path = find_file_target(filename)
    
    next if File.exist?(target_path)

    [File.expand_path(file), target_path]
  end

  files.each do |(source, target)|
    p "Adding symlink from #{target} to #{source}"
    system("ln \"#{source}\" \"#{target}\"")
  end
end

task sync: %w[pull symlinks]

task :pull do
  system('git pull origin master')
end
