require 'rake'

task :default => [:generate]

desc "Deploy to my site"
task :deploy do
  puts `rsync -arl site/ ninjasti@ninjastic.net:~/public_html/thomas`
end

desc "Generate from source"
task :generate do
  setup_folders_and_assets
  generate_main_pages
  generate_blog
end

def setup_folders_and_assets
  puts `mkdir -p site`
  puts `echo "ErrorDocument 404 /404.html" > site/.htaccess`
  puts `rsync -r src/images site`
  puts `rsync -r src/stylesheets site`
  puts `rsync -r src/javascript site`
end

def page(content)
  layout = File.read("src/mainpages/layout.html")
  body = layout.gsub("***CONTENT***", content)
end

def generate_main_pages
  main_pages = Dir.glob("./src/mainpages/*").map{|path|File.basename(path)}
  main_pages.each do |name|
    body = File.read("src/mainpages/#{name}")
    File.open("site/#{name}", "w+") do |f|
      f.write(page(body))
    end
  end
end

# Fix 404 when landing at kjeldahlnilsson.net/blog

def generate_blog
  # TODO first, convert from orgfiles to html files (emacs batch job?)
  # TODO orgmode: find good way to encode title of each post, extract here
  # TODO orgmode: find good way to encode publish date, extract here
  blog_pages = Dir.glob("./src/blog/*").map{|path|File.basename(path)}
  # TODO sort blog_pages based on publish dates, newest date = first in array

  archive = ""
  blog_pages.each_with_index do |name, i|
    title = name # TODO use actual title
    body = File.read("src/blog/#{name}")

    # Add navigation to bottom of post body
    body += "<a href='#{blog_pages[i-1]}'><--Previous</a>" if i > 0
    body += " <a href='archive.html'>Archive</a> "
    body += "<a href='#{blog_pages[i+1]}'>Next--></a>" if i < (blog_pages.size - 1)

    # Write actual post to file
    File.open("site/#{name}", "w+") do |f|
      f.write(page(body))
    end
    
    if i == 0 # The first/most recent post is also index.html of site
      File.open("site/index.html", "w+") do |f|
        f.write(page(body))
      end
    end

    # Link to it from archive page as well
    archive += "<li><a href='#{name}'>#{title}</a></li>"
  end

  # Write out the archive page
  archive = "<ul>#{archive}</ul>"  
  File.open("site/archive.html", "w+") do |f|
    f.write(page(archive))
  end

  # TODO generate rss feed
end
