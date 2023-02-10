# frozen_string_literal: true

require 'pathname'

CUSTOM_DESTINATIONS = {
  'init.lua' => '~/.hammerspoon/init.lua'
}.freeze

def find_file_target(file)
  CUSTOM_DESTINATIONS.fetch(file, File.expand_path("~/.#{file}"))
end

task default: %w[sync]

task :symlinks do
  files = Dir.glob('files/**/*').filter_map do |file|
    next if File.directory?(file)

    pathname = Pathname.new(file)
    filename = pathname.relative_path_from('files')

    [File.join(Pathname.pwd, pathname), find_file_target(filename.to_s)]
  end

  existing_files = []

  force = ENV['OVERRIDE_SYMLINKS'] == 'true'
  flags = { force: force }
  files.each do |(from, to)|
    from = File.expand_path(from)
    to = File.expand_path(to)
    to_folder = File.dirname(to)

    FileUtils.mkdir_p(to_folder) unless Dir.exist?(to_folder)

    begin
      FileUtils.symlink(from, to, **flags)
    rescue Errno::EEXIST
      existing_files << to.split('/').last
      next
    end

    puts "Created symlink from #{from} to #{to}"
  end

  unless existing_files.empty?
    puts "Files #{existing_files.join(', ')} existed  and were ignored. Run with OVERRIDE_SYMLINKS=true to override"
  end
end

task sync: %w[pull symlinks]

task :pull do
  system('git pull origin master')
end
