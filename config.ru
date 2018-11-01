require "rack"
require "rack/contrib/try_static"
require "rack/rewrite"
require "rack/ssl"

# Enable proper HEAD responses
use Rack::Head

# Force SSL
unless ENV["DEV_ENV"]
  use Rack::SSL
end

# Add basic auth if configured
if ENV["HTTP_USER"] && ENV["HTTP_PASSWORD"]
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [ENV["HTTP_USER"], ENV["HTTP_PASSWORD"]]
  end
end

use Rack::Rewrite do
  # Remove .html extension from URL
  r301 %r{(.*)\.html$},                          '$1'
end

# Serve static files
use Rack::TryStatic,
    :root => "_site",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html'],
    :header_rules => [
      [:all,                  {'Cache-Control' => 'public, max-age=3600'}],
      [['css', 'js'],         {'Cache-Control' => 'public, max-age=86400'}],
      [['jpg', 'png', 'gif'], {'Cache-Control' => 'public, max-age=86400'}],
    ]

# Serve a 404 page if all else fails
run lambda { |env|
  [
    404,
    {
      "Content-Type" => "text/html",
      "Cache-Control" => "public, max-age=60"
    },
    File.open("build/404/index.html", File::RDONLY)
  ]
}
