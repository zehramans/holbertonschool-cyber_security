#!/usr/bin/env ruby
require 'open-uri'
require 'uri'
require 'fileutils'

# 1. Check if both arguments (URL and LOCAL_FILE_PATH) are provided
if ARGV.length != 2
  puts "Usage: #{File.basename(__FILE__)} URL LOCAL_FILE_PATH"
  exit 1
end

url = ARGV[0]
local_path = ARGV[1]

# 2. Basic URL validation to ensure it's a valid HTTP/HTTPS link
begin
  uri = URI.parse(url)
  unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    raise URI::InvalidURIError
  end
rescue URI::InvalidURIError
  puts "Error: Invalid URL provided."
  exit 1
end

# 3. Create the destination directory if it doesn't exist
dir_name = File.dirname(local_path)
FileUtils.mkdir_p(dir_name) unless Dir.exist?(dir_name)

# 4. Download and save the file
puts "Downloading file from #{url}..."

begin
  # URI.open handles streaming seamlessly
  URI.open(url) do |remote_file|
    File.open(local_path, 'wb') do |local_file|
      local_file.write(remote_file.read)
    end
  end
  puts "File downloaded and saved to #{local_path}."
rescue StandardError => e
  puts "An error occurred during download: #{e.message}"
  exit 1
end
