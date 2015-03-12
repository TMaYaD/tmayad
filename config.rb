Dotenv.load
###
# Compass
###

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

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

ignore '*.swp'
ignore '*~'

sprockets.append_path File.join "#{root}", "bower_components"
sprockets.append_path File.join "#{root}", "bower_components/foundation/scss"
sprockets.append_path File.join "#{root}", "bower_components/foundation/js"

activate :blog

activate :blog_editor

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Minify Html on build
  activate :minify_html

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  activate :imageoptim

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  activate :gzip

  # activate :favicon_maker, :icons => {
  #   "_favicon_template.png" => [
  #     { icon: "apple-touch-icon-152x152-precomposed.png" },
  #     { icon: "apple-touch-icon-114x114-precomposed.png" },
  #     { icon: "apple-touch-icon-72x72-precomposed.png" },
  #   ]
  # }
end

activate :s3_sync do |s3_sync|
  s3_sync.bucket                = 'tmayad.loonyb.in'
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
