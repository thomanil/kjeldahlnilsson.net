#!/usr/local/bin/ruby

def setup_folders_and_assets
  puts `mkdir -p site`
  puts `rsync -r src/images site/images`
  puts `rsync -r src/stylesheets site/stylesheets`
  puts `rsync -r src/javascript site/javascript`  
end

def page(content)
  layout = File.read("src/layout.html")
  body = layout.gsub("***CONTENT***", content)
end

def generate_page(name)
  index_body = File.read("src/#{name}")
  File.open("site/#{name}", "w+") do |f|
    f.write(page(index_body))
  end
end

setup_folders_and_assets()
pages = ["index.html", "portfolio.html", "contact.html"]
pages.each { |name| generate_page(name)}


puts "Done."

