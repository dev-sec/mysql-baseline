# encoding: utf-8

require 'spec_helper'

ENV['mysql_password'] = 'iloverandompasswordsbutthiswilldo'

RSpec.configure do |c|
  c.filter_run_excluding skipOn: backend(Serverspec::Commands::Base).check_os[:family]
end

case backend.check_os[:family]
when 'Ubuntu'
  mysql_config_file = '/etc/mysql/my.cnf'
  mysql_hardening_file = '/etc/mysql/conf.d/hardening.cnf'
  mysql_config_path = '/etc/mysql/'
  service_name = 'mysql'
when 'RedHat', 'Fedora'
  mysql_config_file = '/etc/my.cnf'
  mysql_hardening_file = '/etc/hardening.cnf'
  mysql_config_path = '/etc/'
  service_name = 'mysqld'
end

tmp_config_file = '/tmp/my.cnf'

describe service("#{service_name}") do
  it { should be_enabled }
  it { should be_running }
end

describe command("cat #{mysql_config_file} | tr -s [:space:]  > #{tmp_config_file}; cat #{mysql_hardening_file} | tr -s [:space:] >> #{tmp_config_file}") do
  it { should return_exit_status 0 }
end

# Req. 294
# show variables like "%version%"; shold contain Enterprise "GA" not Community

# Req. 296
# version > 5 (5.1.58)

# Req. 297
describe command("mysql -uroot -p#{ENV['mysql_password']} -s -e 'show databases like \"test\";'") do
  its(:stdout) { should_not match /test/ }
end

# Req. 298
describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"\";' | tail -1") do
  its(:stdout) { should match /^0/ }
end

# Req. 299
# ps aux | grep mysql | wc -l = 1 (nur eine instanz pro server)

# Req. 300
# Benutzerkonten ohne kennwort select count(*) from mysql.user where length(password)=0 or password="";

# Req. 301
describe file(tmp_config_file) do
  it { should contain 'safe-user-create' }
end

# Req. 302
describe file(tmp_config_file) do
  it { should_not contain 'old_passwords' }
end

# Req. 305    
describe file(tmp_config_file) do
    its(:content) { should match(/user = mysql/) }
end

describe 'Mysql owner, group and permissions' do

  describe file(mysql_config_path) do
    it { should be_directory }
  end

  describe file(mysql_config_path) do
    it { should be_owned_by 'root' }
  end

  describe file(mysql_config_file) do
    it { should be_owned_by 'mysql' }
  end
  
end
