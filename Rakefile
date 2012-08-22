require 'rake'

task :default => [:generate]

desc "Wipe the previously generated site"
task :clean do
  puts `rm -rf site`
end

desc "Generate from source"
task :generate => :clean do
  setup_folders_and_assets
  generate_main_pages
  generate_blog
end

desc "Deploy to my site"
task :deploy do
  puts `rsync -arl site/ ninjasti@ninjastic.net:~/public_html/thomas`
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
  # TODO orgmode: convert from orgfiles to html files (emacs batch job?)
  # TODO orgmode: find good way to encode title of each post, extract here
  # TODO orgmode: find good way to encode publish date, extract here
  # TODO sort blog_pages based on publish dates, newest date = first in array
  blog_pages = Dir.glob("./src/blog/*").map{|path|File.basename(path)}

  archive = ""
  atom_entries = ""

  blog_pages.each_with_index do |name, i|
    published = "13.12.2003" # TODO extract form orgfile
    published_rfc_3339 = "2003-12-13T18:30:02Z" #TODO convert from orgfile    
    title = name # TODO use actual title + publish date

    body = File.read("src/blog/#{name}")

    # Add navigation and subscribe link to bottom of post body
    body += "<div id='anav'>"
    body += "<a href='#{blog_pages[i-1]}'>Previous</a>" if i > 0
    body += "<a href='archive.html'> Archive </a>"
    body += "<a href='#{blog_pages[i+1]}'>Next</a>" if i < (blog_pages.size - 1)
    body += "<a class='right' href='http://feeds.feedburner.com/ThomasKjeldahlNilssonsBlog'>Subscribe</a>"
    body += "</div>"

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
    archive += "<a href='#{name}'>#{published} #{title}</a><br/>"

    # Add Atom feed entry
    atom_entries += atom_entry(title, body, name, published_rfc_3339)
  end
  
  # Write out the archive page
  archive = "<div id='anav'>#{archive}</div>"
  File.open("site/archive.html", "w+") do |f|
    f.write(page(archive))
  end

  # Generate atom feed
  feed = atom_feed(atom_entries)
  File.open("site/atom.xml", "w+") do |f|
    f.write(feed)
  end  
end

def atom_feed(entries)
  current_time = "2003-12-13T18:30:02Z" # TODO
  feed = <<FEED
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
        <title>Thomas Kjeldahl Nilssons blog</title>
        <subtitle>Writings</subtitle>
        <link rel="self" href="http://kjeldahlnilsson.net/atom.xml"/>
        <updated>#{current_time}</updated>
        <author>
                <name>Thomas Kjeldahl Nilsson</name>
                <email>thomas@kjeldahlnilsson.net</email>
        </author>
        <id>http://kjeldahlnilsson.net/</id>
       #{entries}
</feed>
FEED
end

def atom_entry(title, body, link, published)
  entry = <<ENTRY
<entry>
   <title>#{title}</title>
   <content>#{title}</content>
   <link href="#{link}"/>
   <id>http://kjeldahlnilsson.net/#{link}</id>
   <updated>#{published}</updated>
</entry>
ENTRY
end
