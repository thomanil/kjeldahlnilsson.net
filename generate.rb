#!/usr/local/bin/ruby

def page(content)
  body = <<LAYOUT
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8"> 
    <link rel="stylesheet" type="text/css" href="stylesheets/style.css" />
    <title>Thomas Kjeldahl Nilsson</title>
  </head>

  <body>
    <div id="head">
      <h1>Thomas Kjeldahl Nilsson</h1>
    </div>

    <div id="navbar">
      <ul>
        <li><a href="index.html">About</a></li>
        <li><a href="portfolio.html">Portfolio</a></li>
        <li><a href="contact.html">Contact</a></li>
      </ul>
    </div>
    
    <div id="content">
      #{content}
    </div>

    <div id="foot">
      &copy 2012 Thomas Kjeldahl Nilsson
    </div>

    <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("UA-8094387-2");
      pageTracker._trackPageview();
      } catch(err) {}</script>
  </body>
</html>
LAYOUT
end


def setup_folders_and_assets
  puts `mkdir -p site`
  puts `rsync -r src/images site/images`
  puts `rsync -r src/stylesheets site/stylesheets`
  puts `rsync -r src/javascript site/javascript`  
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

