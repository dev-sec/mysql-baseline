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

# Req. 297
describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'show databases like \"test\";'") do
  it { should return_stdout nil }
end

# Req. 298
describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"\";' | tail -1") do
  it { should return_stdout "0" }
end

# Req. 302
describe file(mysql_config_file) do
  it { should contain 'password' }
end

describe 'Mysql owner, group and permissions' do

  describe file('/etc/mysql') do
    it { should be_directory }
  end

  describe file('/etc/mysql') do
    it { should be_owned_by 'root' }
  end

end
