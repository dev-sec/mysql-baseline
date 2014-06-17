# encoding: utf-8

require 'spec_helper'

RSpec.configure do |c|
  c.filter_run_excluding skipOn: backend(Serverspec::Commands::Base).check_os[:family]
end

case backend.check_os[:family]
when 'Ubuntu'
  mysql_config_file = '/etc/mysql/my.cnf'
when 'RedHat', 'Fedora'
  mysql_config_file = '/etc/my.cnf'
end

describe 'Mysql owner, group and permissions' do

  describe file('/etc/mysql') do
    it { should be_directory }
  end

  describe file('/etc/mysql') do
    it { should be_owned_by 'root' }
  end

end
