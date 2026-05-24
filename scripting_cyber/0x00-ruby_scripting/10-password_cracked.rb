#!/usr/bin/env ruby
require 'digest'

# 1. Check if both arguments are provided
if ARGV.length != 2
  puts "Usage: #{File.basename(__FILE__)} HASHED_PASSWORD DICTIONARY_FILE"
  exit 1
end

target_hash = ARGV[0].downcase.strip
dictionary_file = ARGV[1]

# 2. Check if the dictionary file exists before proceeding
unless File.exist?(dictionary_file)
  puts "Error: Dictionary file '#{dictionary_file}' not found."
  exit 1
end

found_password = nil

# 3. Read the dictionary file line by line
begin
  File.foreach(dictionary_file) do |line|
    # Strip any trailing newlines or whitespaces from the word
    word = line.strip
    next if word.empty?

    # Compute the SHA-256 hash of the word
    word_hash = Digest::SHA256.hexdigest(word)

    # Compare the generated hash with the target hash
    if word_hash == target_hash
      found_password = word
      break
    end
  end
rescue StandardError => e
  puts "An error occurred while reading the file: #{e.message}"
  exit 1
end

# 4. Output the result based on whether the password was cracked
if found_password
  puts "Password found: #{found_password}"
else
  puts "Password not found in dictionary."
end
