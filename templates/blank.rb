# Remove the file on both *unix and Windows
if Gem.win_platform?
  run "del public\\index.html"
else
  run "rm public/index.html"
end

# Loads the version, so we can explicitly set in the generated cms project.
template_root = File.dirname(File.expand_path(template))
require File.join(template_root, '..', 'lib', 'cms', 'version.rb')
gem "browsercms", :version=>Cms::VERSION

generate :jdbc if defined?(JRUBY_VERSION)

if Gem.win_platform?
  puts "        rake  db:create"
  `rake.cmd db:create`
else
  rake "db:create"
end
route "map.routes_for_browser_cms"
generate :browser_cms
environment 'SITE_DOMAIN="localhost:3000"', :env => "development"
environment 'SITE_DOMAIN="localhost:3000"', :env => "test"
environment 'SITE_DOMAIN="localhost:3000"', :env => "production"
environment 'config.action_view.cache_template_loading = false', :env => "production"
environment 'config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"', :env => "production"
initializer 'browsercms.rb', <<-CODE
Cms.attachment_file_permission = 0640
CODE
if Gem.win_platform?
  puts "        rake  db:migrate"
  `rake.cmd db:migrate`
else
  rake "db:migrate"
end
