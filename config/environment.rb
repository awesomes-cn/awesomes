# Load the Rails application.
require File.expand_path('../application', __FILE__)
Slim::Engine.set_default_options attr_delims: { '[' => ']','(' => ')' }
Slim::Engine.set_default_options pretty: true, sort_attrs: false
# Initialize the Rails application.
Rails.application.initialize!
