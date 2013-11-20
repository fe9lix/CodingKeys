# Reads JSON of the keys file and 
# generates markdown syntax for a table

require "json"

@keys_file_path =  File.expand_path(
  "../../CodingKeys/data/keys.json", __FILE__)
@keys = JSON.parse(File.read(@keys_file_path))

def all_mapped_apps
  apps = {}
  @keys.each do |key_mapping|
    apps = apps.merge(key_mapping["mapping"])
  end
  apps.keys.sort
end

def make_row(values)
  "| " + values.join(" | ") + " | \n"
end

def make_separator(length)
  make_row(length.times.collect { "-----" })
end

def make_table
  apps = all_mapped_apps
  header = apps.clone.unshift("Command", "Key")

  markdown_str = ""
  markdown_str += make_row(header)
  markdown_str += make_separator(header.count)

  @keys.each do |key_mapping|
    row = [
      "**#{key_mapping["command"]}**", 
      "**`#{key_mapping["key"]}`**"]
    mapping = key_mapping["mapping"]
    apps.each do |app|
      mapped_key = mapping[app]
      mapped_key.gsub!("|", "&#124;")
      row << "#{mapped_key}" || " "
    end
    markdown_str += make_row(row)
  end

  markdown_str
end

puts make_table