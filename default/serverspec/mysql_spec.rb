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

RSpec.configure do |c|
  c.filter_run_excluding skipOn: backend(Serverspec::Commands::Base).check_os[:family]
end

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

  # SEC: Req 3.24-1 (keine Community-version)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select version();' | tail -1") do
    its(:stdout) { should_not match(/Community/) }
  end

  # SEC: Req 3.24-1 (version > 5)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select substring(version(),1,1);' | tail -1") do
    its(:stdout) { should match(/^5/) }
  end

  # SEC: Req 3.24-2 (keine default-datenbanken)
  describe command("mysql -uroot -p#{ENV['mysql_password']} -s -e 'show databases like \"test\";'") do
    its(:stdout) { should_not match(/test/) }
  end

  # SEC: Req 3.24-3 (keine anonymous-benutzer)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # SEC: Req 3.24-5 (keine benutzerkonten ohne kennwort)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where length(password)=0 or password=\"\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # SEC: Req 3.24-23 (no grant privileges)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where grant_priv=\"y\" and User!=\"root\" and User!=\"debian-sys-maint\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # SEC: Req 3.24-27 (keine host-wildcards)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where host=\"%\"' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # SEC: Req 3.24-28 (root-login nur von localhost)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"root\" and host not in (\"localhost\",\"127.0.0.1\",\"::1\")' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

end

# SEC: Req 3.24-4 (nur eine instanz pro server)
describe 'Req. 299: check for multiple instances' do
  describe command('ps aux | grep mysqld | egrep -v "grep|mysqld_safe|logger" | wc -l') do
    its(:stdout) { should match(/^1$/) }
  end
end

describe 'Parsing configfiles for unwanted entries' do

  # SEC: Req 3.24-6 (safe-user-create = 1)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('safe-user-create', '1') }
  end

  # SEC: Req 3.24-7 (no old_passwords)
  describe file(tmp_config_file) do
    its(:content) { should_not match_key_value('old_passwords', '1') }
  end

  # SEC: Req 3.24-8 (secure-auth = 1)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('secure-auth', '1') }
  end

  # SEC: Req 3.24-11 (user = mysql)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('user', 'mysql') }
  end

  # SEC: Req 3.24-13 (skip-symbolic-links = 1)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('skip-symbolic-links', '1') }
  end

  # SEC: Req 3.24-15 (secure-file-priv)
  describe file(tmp_config_file) do
    its(:content) { should match(/^\s*?secure-file-priv/) }
  end

  # SEC: Req 3.24-16 (local-infile = 0)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('local-infile', '0') }
  end

  # SEC: Req 3.24-21 (skip-show-database)
  describe file(tmp_config_file) do
    its(:content) { should match(/^\s*?skip-show-database/) }
  end

  # SEC: Req 3.24-22 (skip-grant-tables)
  describe file(tmp_config_file) do
    its(:content) { should_not match(/^\s*?skip-grant-tables/) }
  end

  # SEC: Req 3.24-26 (kein "allow-suspicious-udfs")
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('allow-suspicious-udfs', '0') }
  end

end

# SEC: Req 3.24-17, SEC: Req 3.24-18, SEC: Req 3.24-19
describe 'SEC: Req 3.24-17, SEC: Req 3.24-18, SEC: Req 3.24-19: Mysql-data owner, group and permissions' do

  describe file(mysql_data_path) do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file("#{mysql_data_path}/ibdata1") do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
    it { should_not be_readable.by('others') }
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
