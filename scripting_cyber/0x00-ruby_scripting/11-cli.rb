#!/usr/bin/env ruby
require 'optparse'

TASKS_FILE = 'tasks.txt'

# Helper method to load tasks from the file
def load_tasks
  if File.exist?(TASKS_FILE)
    File.readlines(TASKS_FILE).map(&:chomp)
  else
    []
  end
end

# Helper method to save tasks back to the file
def save_tasks(tasks)
  File.open(TASKS_FILE, 'w') do |file|
    tasks.each { |task| file.puts(task) }
  end
end

options = {}

# Define and parse options
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", "Remove a task by index") do |index|
    options[:remove] = index.to_i
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end

# Parse ARGV. If no valid options are provided, or -h is called, OptionParser handles it.
begin
  opt_parser.parse!
rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
  puts e.message
  puts opt_parser
  exit 1
end

# Execute behavior based on options
if options[:add]
  tasks = load_tasks
  tasks << options[:add]
  save_tasks(tasks)
  puts "Task '#{options[:add]}' added."

elsif options[:list]
  tasks = load_tasks
  if tasks.empty?
    puts "No tasks found."
  else
    tasks.each_with_index do |task, idx|
      puts "#{idx + 1}. #{task}"
    end
  end

elsif options[:remove]
  tasks = load_tasks
  index = options[:remove] - 1 # Convert 1-based UI index to 0-based array index

  if index >= 0 && index < tasks.length
    removed_task = tasks.delete_at(index)
    save_tasks(tasks)
    puts "Task '#{removed_task}' removed."
  else
    puts "Error: Invalid task index."
    exit 1
  end

else
  # Default behavior if executed without arguments
  puts opt_parser
end
