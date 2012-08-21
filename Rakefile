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
  generate_main_pages
  generate_blog_posts
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

def generate_main_pages
  main_pages = ["about.html", "portfolio.html", "contact.html"]
  main_pages.each do |name|
    body = File.read("src/#{name}")
    File.open("site/#{name}", "w+") do |f|
      f.write(page(body))
    end
  end
end

def generate_blog_posts
  # TODO convert from orgfiles to html first
  # TODO derive title field & link description from blog post name

  blog_pages = ["first.html", "second.html"] # NOTE: first element in array is newest post!

  # Write each blog post into its own html file directly under /site
  # TODO add links to prev and next posts
  # TODO each blog post should have disqus footer
  blog_pages.each_with_index do |name, i|
    body = File.read("src/blog/#{name}")
    File.open("site/#{name}", "w+") do |f|
      f.write(page(body))
    end
    if i == 0 # First post = also use as index page
      File.open("site/index.html", "w+") do |f|
        f.write(page(body))
      end
    end
  end

  # Create archive list page
  body = "<ul><li><a href='first.html'>First</a></li>  <li><a href='second.html'>Second</a></li> </ul>"
  File.open("site/archive.html", "w+") do |f|
    f.write(page(body))
  end
end
