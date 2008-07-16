unless defined?(DataMapper::AutoMigrator)
  # If it's not even defined, dm-migrations could be required later and
  # re-enable auto_migrate, so let's require the class only to clobber it.
  require 'dm-migrations'
end

# re-open the 
module DataMapper
  class AutoMigrator
    def self.auto_migrate(*args)
      puts "Preventing automigration.  If you really want to automigrate, first remove the dm-disable-automigrate plugin."
    end
  end

  module AutoMigrations
    def auto_migrate!(*args)
      puts "Preventing automigration.  If you really want to automigrate, first remove the dm-disable-automigrate plugin."
    end
  end
end
