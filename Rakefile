require 'rake'

task :default => [:generate]

desc "Deploy to my site"
task :deploy do
  puts `rsync -arl site/* ninjasti@ninjastic.net:~/public_html/thomas`
  puts "Deployed."
end

desc "Generate from source"
task :generate do
  setup_folders_and_assets()
  pages = ["index.html", "portfolio.html", "contact.html"]
  pages.each { |name| generate_page(name)}
  puts "Generated."
end

def setup_folders_and_assets
  puts `mkdir -p site`
  puts `rsync -r src/images site`
  puts `rsync -r src/stylesheets site`
  puts `rsync -r src/javascript site`  
end

def page(content)
  layout = File.read("src/layout.html")
  body = layout.gsub("***CONTENT***", content) # Don't need erb yet :)
end

def generate_page(name)
  body = File.read("src/#{name}")
  File.open("site/#{name}", "w+") do |f|
    f.write(page(body))
  end
end

