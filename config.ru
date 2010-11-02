require 'rubygems'
require 'rack'
require 'compass'
require 'rack_haml_sass_generator'
require 'sass/plugin/rack'
require 'fileutils'

# Create some directories off tmp that SASS will require.
cssdir = File.expand_path("../tmp/stylesheets/compiled", __FILE__)
cachedir = File.expand_path("../tmp/sass-cache", __FILE__)
FileUtils.mkdir_p(cssdir)
FileUtils.mkdir_p(cachedir)


# Configure SASS where to compile the stylesheets
Sass::Plugin.options[:css_location] = cssdir
Sass::Plugin.options[:cache_location] = cachedir
Sass::Plugin.options[:template_location] = File.expand_path("../public/stylesheets/sass", __FILE__) 

# Setup compass. Calling the below Rails specific code seems to
# be good enough. Not sure if there is a better way.
Compass::AppIntegration::Rails.initialize!

use Rack::SiteGenerator #haml
use Sass::Plugin::Rack
# Tell Rack where to pick up the compiled stylesheets
use Rack::Static, :urls => ["/stylesheets/compiled"], :root => "tmp"
use Rack::Static, :urls => ["/index.html"], :root => "public"
run lambda { |env| []}
