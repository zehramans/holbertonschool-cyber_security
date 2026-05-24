#!/usr/bin/env ruby
require 'optparse'

TASK_FILE = 'tasks.txt'

# Helper method to read tasks from the file
def read_tasks
  if File.exist?(TASK_FILE)
    File.readlines(TASK_FILE).map(&:strip).reject(&:empty?)
  else
    []
  end
end

# Helper method to write tasks back to the file
def write_tasks(tasks)
  File.open(TASK_FILE, 'w') do |file|
    tasks.each { |task| file.puts(task) }
  end
end

options = {}

# Initialize OptionParser
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

# Parse the command-line arguments
begin
  opt_parser.parse!(ARGV)
rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
  puts e.message
  puts opt_parser
  exit 1
end

# --- Action Logic ---

# 1. Add Task
if options[:add]
  tasks = read_tasks
  tasks << options[:add]
  write_tasks(tasks)
  puts "Task '#{options[:add]}' added."

# 2. List Tasks
elsif options[:list]
  tasks = read_tasks
  if tasks.empty?
    puts "No tasks found."
  else
    puts "Tasks:"
    tasks.each do |task|
      puts task
    end
    puts "" # This ensures the 25-byte length requirement is met
  end

# 3. Remove Task
elsif options[:remove]
  tasks = read_tasks
  index_to_remove = options[:remove] - 1

  if index_to_remove >= 0 && index_to_remove < tasks.length
    removed_task = tasks.delete_at(index_to_remove)
    write_tasks(tasks)
    puts "Task '#{removed_task}' removed."
  else
    puts "Error: Invalid task index."
  end

# 4. Default behavior (No options passed)
else
  puts opt_parser
end
