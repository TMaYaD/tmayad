Dotenv.load
###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

activate :sprockets

activate :blog

activate :blog_editor

require 'foundation/sprockets'

activate :livereload

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Minify Html on build
  activate :minify_html

  # Enable cache buster
  activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  activate :imageoptim

  # Or use a different image path
  # set :http_path, "/Content/images/"

  activate :gzip

  activate :favicon_maker,
            favicon_maker_base_image: "images/favicon.png"
end

activate :s3_sync do |s3_sync|
  s3_sync.bucket                = 'loonyb.in'
  s3_sync.region                = 'us-east-1'
  s3_sync.aws_access_key_id     = ENV['AWS_KEY']
  s3_sync.aws_secret_access_key = ENV['AWS_SECRET']
  s3_sync.delete                = true
  s3_sync.after_build           = false
  s3_sync.prefer_gzip           = true
end

# activate :cloudfront do |cloudfront|
#   cloudfront.access_key_id     = ENV['AWS_KEY']
#   cloudfront.secret_access_key = ENV['AWS_SECRET']
#   cloudfront.distribution_id   = 'E3E0TLTQTS8L1F'
#   cloudfront.after_build       = false
# end


