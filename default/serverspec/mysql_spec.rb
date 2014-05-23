require 'spec_helper'

RSpec.configure do |c|
    c.filter_run_excluding :skipOn => backend(Serverspec::Commands::Base).check_os[:family]
end

describe 'Mysql owner, group and permissions' do

  describe file('/etc/mysql') do
    it { should be_directory }
  end

  describe file('/etc/mysql') do
    it { should be_owned_by 'root' }
  end

end
