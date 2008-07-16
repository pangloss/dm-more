# Requiring dm-more itself adds its payload of gems directly to the path. That
# allows them to be required without being installed as gems.  This is
# especially useful when vendoring dm-more, and more specifically to prevent
# versioning problems if this gem is updated but "rake install" has not been
# rerun on the gems it contains.

require 'pathname'

dir = File.join(Pathname(__FILE__).dirname.expand_path, '..')

Dir[File.join(dir, '*')].each do |dm_gem|
  $:.unshift(File.join(dm_gem, 'lib'))
end

