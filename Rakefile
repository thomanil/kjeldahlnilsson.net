# -*- coding: utf-8 -*-
require 'rake'
require 'time'
require 'nokogiri'

task :default => [:generate]

desc "Wipe the previously generated site"
task :clean do
  puts `rm -rf site`
  puts `rm -rf src/blog/*.html`
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

def generate_blog
  blog_posts = []

  # TODO Firing up emacs once for each file = super slow.
  #      Write some custom elisp to do all files in one go
  Dir.glob("./src/blog/*.org").each do |path|
    `emacs --batch --visit=#{path} --funcall org-export-as-html`
    doc = Nokogiri::HTML(File.read(path.gsub(".org", ".html")))
    title = doc.css("title").text
    body = doc.css("#content").to_html # Just grabbing the content div, drop the rest
    published = doc.xpath("//meta[@name='generated']").attribute("content").text
    published_rfc_3339 = Time.parse(published).xmlschema
    filename = File.basename(path).gsub(".org", ".html")
    blog_posts << {:title => title,
      :published => published,
      :published_rfc_3339 => published_rfc_3339,
      :body => body,
      :filename => filename}
  end
    
  # Sort based on publish date, ascending age
  blog_posts = blog_posts.sort_by{|p| Time.parse(p[:published]).tv_sec}.reverse
  
  archive = ""
  atom_entries = ""

  blog_posts.each_with_index do |post, i|
    name = post[:filename]
    title = post[:title]
    body = post[:body]
    published = post[:published]
    published_rfc_3339 = post[:published_rfc_3339]

    # Add navigation and subscribe link to bottom of post body
    body += "<div id='anav'>"
    body += "<a href='#{blog_posts[i-1][:filename]}'>Newer </a>" if i > 0
    body += "<a href='archive.html''>Archive</a>"	
    body += "<a href='#{blog_posts[i+1][:filename]}'> Older</a>" if i < (blog_posts.size - 1)
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
  feed = <<FEED
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
        <title>Thomas Kjeldahl Nilssons blog</title>
        <subtitle>Writings</subtitle>
        <link rel="self" href="http://kjeldahlnilsson.net/atom.xml"/>
        <updated>#{Time.now.xmlschema}</updated>
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


###################
# TMP Wordpress import
##################¤

task :import do
  
  # TODO pull out blogposts from xml file


  
  # TODO for each blogpost:
  create_orgfile("imported-blog-post.org", "Imported Blog post", "08.08.1988", "<em>This is a test</em>")
  
end

def create_orgfile(filename, title, publish_date, content)
  File.open("src/blog/#{filename}", "w+") do |f|
    f.write(orgfile_body(title, publish_date, content))
  end
end

def orgfile_body(title, publish_date, content)
  body = <<TEMPLATE
#+TITLE:     #{title}
#+EMAIL:     thomas@kjeldahlnilsson.net
#+DATE:      #{publish_date}
#+DESCRIPTION:
#+KEYWORDS:
#+LANGUAGE:  en
#+OPTIONS: H:3 num:nil toc:nil @:t ::t |:t ^:t -:t f:t *:t <:t 
#+OPTIONS: TeX:t LaTeX:t skip:nil d:nil todo:t pri:nil tags:not-in-toc
#+INFOJS_OPT: view:nil toc:nil ltoc:t mouse:underline buttons:0 path:http://orgmode.org/org-info.js
#+EXPORT_SELECT_TAGS: export
#+EXPORT_EXCLUDE_TAGS: noexport
#+LINK_UP:
#+LINK_HOME:
#+XSLT:

#+BEGIN_HTML
  #{content}
#+END_HTML
TEMPLATE
end
