#!/usr/bin/env ruby

def read_inbox_directory(directory)
  # list files w/ links
  inbox_files = {}
  rbfiles = File.join("**", "*.md")
  Dir.chdir(directory) do
    Dir.glob(rbfiles).sort_by{ |f| File.mtime(f) }.reverse.each do |filename|
    inbox_files[filename.chomp('.md')] = "[[#{filename}]]\n"
    end
  end
  return inbox_files
end

def read_markdown_directory(raw_directory)
  contents = {}
  rbfiles = File.join("**", "*.md")
  Dir.chdir(raw_directory) do
    Dir.glob(rbfiles).sort_by{ |f| File.mtime(f) }.reverse.each do |filename|
      # find @@todo-skip in a file? skip it
      unless filename == 'TODO.md' || filename.downcase().include?('skip-todo')
        contents[filename.chomp('.md')] = File.read(filename, :encoding => 'utf-8')
      end
    end
  end      
  return contents
end

def extract_todo_lines(contents)
  todo_lines = {}
  file_counter = 0
  contents.each do |filename, content|
    todo_text = ''
    content.scan(/[\*\-+]\s\[\s\]\s(.*)/).flatten.each do |match|
      todo_text += "- #{match} [[#{filename}]]\n"
    end
    if not todo_text.empty? #unless todo_text.empty?
      todo_text = "#### #{filename}\n[[#{filename}]]\n" + todo_text 
      file_counter = file_counter + 1
    end
    todo_lines[filename] = todo_text # unless todo_text.empty?
  end
  return todo_lines, file_counter
end

def write_simple_todo_file(inbox_files, filepath, todo_lines, files_scanned, todo_count)
  File.open(filepath, 'w') do |file|
    file.write("# TODO\n\n")

    unless inbox_files.empty?
      file.write("### 🚨 Inbox Files 🚨\n")
      inbox_files.each do | filename, ref |
        file.write("#{ref}")
      end
    end

    todo_notes = todo_lines.map{ |k,v| v }.join
    file.write("#{todo_notes}\n\n---\n#{files_scanned}\n#{todo_count}")
  end
end

def write_todo_file(filepath, todo_lines)
  File.open(filepath, 'w') do |file|
    file.write "# TODO\n\n"
    todo_lines.each do |filename, lines|
      file.write "## #{filename}\n\n#{lines}\n"
    end
  end
end 

# TODO: make env. var
notes_path = '/Users/devlon.d/obsidian-vault/' # "#{ENV['HOME']}/Notes/"
todo_filepath = notes_path + 'TODO.md'

inbox_files = read_inbox_directory(notes_path + "inbox/")

notes = read_markdown_directory(notes_path)
files_scanned_count = notes.count
file_count_message = "#{files_scanned_count} scanned files"

extract_todo_lines_results = extract_todo_lines(notes)
todo_lines = extract_todo_lines_results[0]
todo_count_message = "#{extract_todo_lines_results[1]} files with todo items"

write_simple_todo_file(inbox_files, todo_filepath, todo_lines, file_count_message, todo_count_message)
