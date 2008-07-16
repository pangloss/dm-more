require 'rubygems'
gem 'rspec', '>=1.1.3'
require 'spec'
require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'lib/dm-disable-automigrate'

def load_driver(name, default_uri)
  false
end
