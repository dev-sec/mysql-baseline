# encoding: utf-8
#
# Copyright 2014, Deutsche Telekom AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

ENV['mysql_password'] = 'iloverandompasswordsbutthiswilldo'

RSpec::Matchers.define :match_key_value do |key, value|
  match do |actual|
    actual =~ /^\s*?#{key}\s*?=\s*?#{value}/
  end
end

mysql_hardening_file = '/etc/mysql/conf.d/hardening.cnf'

# set OS-dependent filenames and paths
case backend.check_os[:family]
when 'Ubuntu', 'Debian'
  mysql_config_file = '/etc/mysql/my.cnf'
  mysql_config_path = '/etc/mysql/'
  mysql_data_path = '/var/lib/mysql/'
  mysql_log_path = '/var/log/'
  mysql_log_file = 'mysql.log'
  mysql_log_group = 'adm'
  os[:release] == '14.04' ? mysql_log_dir_group = 'syslog' : mysql_log_dir_group = 'root'
  service_name = 'mysql'
when 'RedHat', 'Fedora'
  mysql_config_file = '/etc/my.cnf'
  mysql_config_path = '/etc/'
  mysql_data_path = '/var/lib/mysql/'
  mysql_log_path = '/var/log/'
  mysql_log_file = 'mysqld.log'
  mysql_log_group = 'mysql'
  mysql_log_dir_group = 'root'
  service_name = 'mysqld'
end

tmp_config_file = '/tmp/my.cnf'

describe service("#{service_name}") do
  it { should be_enabled }
  it { should be_running }
end

# temporarily combine config-files and remove spaces
describe 'Combining configfiles' do
  describe command("cat #{mysql_config_file} | tr -s [:space:]  > #{tmp_config_file}; cat #{mysql_hardening_file} | tr -s [:space:] >> #{tmp_config_file}") do
    it { should return_exit_status 0 }
  end
end

describe 'Checking MySQL-databases for risky entries' do

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select version();' | tail -1") do
    its(:stdout) { should_not match(/Community/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select substring(version(),1,1);' | tail -1") do
    its(:stdout) { should match(/^5/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} -s -e 'show databases like \"test\";'") do
    its(:stdout) { should_not match(/test/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where length(password)=0 or password=\"\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where grant_priv=\"y\" and User!=\"root\" and User!=\"debian-sys-maint\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where host=\"%\"' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"root\" and host not in (\"localhost\",\"127.0.0.1\",\"::1\")' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

end


describe 'Check for multiple instances' do
  describe command('ps aux | grep mysqld | egrep -v "grep|mysqld_safe|logger" | wc -l') do
    its(:stdout) { should match(/^1$/) }
  end
end

describe 'Parsing configfiles for unwanted entries' do

  
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('safe-user-create', '1') }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should_not match_key_value('old_passwords', '1') }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('secure-auth', '1') }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('user', 'mysql') }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('skip-symbolic-links', '1') }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match(/^\s*?secure-file-priv/) }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('local-infile', '0') }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match(/^\s*?skip-show-database/) }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should_not match(/^\s*?skip-grant-tables/) }
  end

  
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('allow-suspicious-udfs', '0') }
  end

end


describe 'Mysql-data owner, group and permissions' do

  describe file(mysql_data_path) do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file("#{mysql_data_path}/ibdata1") do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end

  describe file(mysql_log_path) do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into mysql_log_dir_group }
  end

  describe file("#{mysql_log_path}/#{mysql_log_file}") do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into mysql_log_group }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end

end

describe 'Mysql-config: owner, group and permissions' do

  describe file(mysql_config_path) do
    it { should be_directory }
  end

  describe file(mysql_config_path) do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file(mysql_config_file) do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_readable.by('others') }
  end

  # test this only if we have a mysql_hardening_file

  if command("ls #{mysql_hardening_file}").return_exit_status?(0)
    describe file(mysql_hardening_file) do
      it { should be_owned_by 'mysql' }
      it { should be_grouped_into 'root' }
      it { should_not be_readable.by('others') }
    end
  end

end

describe 'Mysql environment' do

  
  describe command('env') do
    it { should_not return_stdout(/^MYSQL_PWD=/) }
  end

end
