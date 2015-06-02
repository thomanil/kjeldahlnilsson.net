# -*- coding: utf-8 -*-
require 'rake'
require 'time'
require 'nokogiri'
require 'org-ruby'

task :default => [:generate, :deploy]

desc "Wipe the previously generated site"
task :clean do
  `rm -rf site`
  `rm -rf tmp`
  `rm -rf ~/.org-timestamps` # Or org-publish will deem things unmodified and do nothing
end

desc "Generate from source"
task :generate => :clean do
  prepare_folders_and_assets
  generate_main_pages
  generate_blog
end

desc "Deploy to my site"
task :deploy do
  puts "Deploying..."
  puts `rsync -arl site/ root@kjeldahlnilsson.net:/var/www/kjeldahlnilsson.net/`
end

def prepare_folders_and_assets
  puts "Preparing folders and assets..."
  puts `mkdir -p site`
  puts `mkdir -p tmp`
  puts `rsync -r src/images site`
  puts `rsync -r src/stylesheets site`
  puts `rsync -r src/javascript site`
  puts `echo "ErrorDocument 404 /404.html" > site/.htaccess`
end

def layouted(content)
  layout = File.read("src/mainpages/layout.html")
  body = layout.gsub("***CONTENT***", content)
end

def generate_main_pages
  main_pages = Dir.glob("./src/mainpages/*").map{|path|File.basename(path)}
  main_pages.each do |name|
    body = File.read("src/mainpages/#{name}")
    File.open("site/#{name}", "w+") do |f|
      if name == "404.html"
        f.write(body)
      else
        f.write(layouted(body))
      end
    end
  end
end


def transform_orgfiles
  blog_posts = []

  Dir.glob("./src/blog/*.org").each do |exported_orgfile_path|

    org_body = File.read(exported_orgfile_path)
    filebody = Orgmode::Parser.new(org_body).to_html

    html_filename = File.basename(exported_orgfile_path)
    lines = File.readlines(exported_orgfile_path)

    title = lines.select { |name| name[/#[+]TITLE/i] }[0].gsub("#+TITLE:","").strip
    published = lines.select { |name| name[/#[+]DATE/i] }[0].gsub("#+DATE:","").strip
    filebody = "<span id='date'>#{published}</span><hr/>"+filebody

    if published != "unpublished"
      published_rfc_3339 = Time.parse(published).xmlschema
      blog_posts << {:title => title,
                     :body => filebody,
                     :filename => html_filename,
                     :published => published,
                     :published_rfc_3339 => published_rfc_3339
      }
    end
  end

  blog_posts.sort_by{|p|Time.parse(p[:published]).tv_sec}.reverse
end

def generate_blog
  puts "Transforming orgfiles into html content..."
  blog_posts = transform_orgfiles

  archive_links = ""
  atom_entries = ""

  puts "Generating html pages..."
  blog_posts.each_with_index do |post, i|
    name = post[:filename]
    title = post[:title]
    body = post[:body]
    published = post[:published]
    published_rfc_3339 = post[:published_rfc_3339]

    body += "<hr/>"
    body += "<span id='anav'>"
    body += "<a href='#{blog_posts[i+1][:filename]}'>Previous</a>" if i < (blog_posts.size - 1)
    body += "<a class='right' href='#{blog_posts[i-1][:filename]}'>Next</a>" if i > 0
    body += "</span>"

    # Write actual post to file
    File.open("site/#{name}", "w+") do |f|
      f.write(layouted(body))
    end

    if i == 0 # The first/most recent post is also index.html of site
      File.open("site/index.html", "w+") do |f|
        f.write(layouted(body))
      end
    end

    # Link to it from archive page as well
    archive_links += "<a href='#{name}'>#{published} #{title}</a><br/>"

    # Add Atom feed entry
    atom_entries += atom_entry(title, body, name, published_rfc_3339)
  end

  puts "Generating the archive page..."
  archive = "<div id='anav'>#{archive_links}</div>"
  File.open("site/archive.html", "w+") do |f|
    f.write(layouted(archive))
  end

  puts "Generating atom feed..."
  feed = atom_feed(atom_entries)
  File.open("site/atom.xml", "w+") do |f|
    f.write(feed)
  end

  puts "Cleaning up tmp workdir..."
  puts `rm -rf tmp`
end

def atom_feed(entries)
  feed = <<FEED
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
        <title>Thomas Kjeldahl Nilssons blog</title>
        <subtitle>Programming, entrepreneurship, design, drawing</subtitle>
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
   <title>#{escaped(title)}</title>
   <content>#{escaped(title)}</content>
   <link href="#{link}"/>
   <id>http://kjeldahlnilsson.net/#{link}</id>
   <updated>#{published}</updated>
</entry>
ENTRY
end

def escaped(str)
  if str.class == String
    str.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;").gsub("'", "&apos;").gsub("\"", "&quot;")
  end
end
