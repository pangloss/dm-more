require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

# the corresponding case is tested in the dm-disable-automigrate spec
describe 'without dm-disable-automigrate' do
  it 'should not disable auto_migrate' do
    model = mock('model')
    model.should_receive(:auto_migrate!)
    DataMapper::Resource.should_receive(:descendants).and_return([model])
    DataMapper::AutoMigrator.should_not_receive(:puts)
    DataMapper::AutoMigrator.auto_migrate
  end
end
