require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

# the corresponding case is tested in the dm-migrations spec
describe 'dm-disable-automigrate' do
  it 'should disable auto_migrate' do
    DataMapper::Resource.should_not_receive(:descendants)
    DataMapper::AutoMigrator.should_receive(:puts).with("Preventing automigration.  If you really want to automigrate, first remove the dm-disable-automigrate plugin.")
    DataMapper::AutoMigrator.auto_migrate
  end
end
