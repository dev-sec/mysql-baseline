# frozen_string_literal: true

# Copyright:: 2014, Deutsche Telekom AG
# Copyright:: 2018, Christoph Hartmann
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

mysql_hardening_file = '/etc/mysql/conf.d/hardening.cnf'

user = input('user')
pass = input('password')

# get mysql version and distribution
version = mysql_version(user, pass)
distribution = mysql_distribution(user, pass)

# get datadir and logfile-path from settings in the configuration if it is defined or from mysql itself
mysql_data_path = if mysql_conf&.params&.mysqld&.datadir
                    mysql_conf.params.mysqld.datadir
                  else
                    command("mysql -u#{user} -p#{pass} -sN -e \"select @@GLOBAL.datadir\";").stdout.strip
                  end

mysql_log_file = if mysql_conf.params.mysqld && mysql_conf.params.mysqld['log-error']
                   mysql_conf.params.mysqld['log-error']
                 else
                   command("mysql -u#{user} -p#{pass} -sN -e \"select @@GLOBAL.log_error\";").stdout.strip
                 end

# set OS-dependent filenames and paths
case os[:family]
when 'ubuntu', 'debian'
  mysql_config_path = '/etc/mysql/'
  mysql_config_file = "#{mysql_config_path}my.cnf"
  mysql_log_group = 'adm'
  service_name = 'mysql'
when 'redhat', 'fedora'
  mysql_config_path = '/etc/'
  mysql_config_file = "#{mysql_config_path}my.cnf"
  mysql_log_group = 'mysql'
  service_name = 'mysqld'
  service_name = 'mariadb' if os[:release] >= '7'
end

control 'mysql-conf-01' do
  impact 0.5
  title 'ensure the service is enabled and running'
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end

# 'Check for multiple instances' do
control 'mysql-conf-02' do
  impact 0.5
  title 'only one instance of mysql should run on a server'
  describe command('pgrep -x -c mysqld') do
    its(:stdout) { should match(/^1$/) }
  end
end

# Parsing configfiles for unwanted entries
control 'mysql-conf-03' do
  impact 0.7
  title 'enable secure configurations for mysql'
  describe mysql_conf.params('mysqld') do
    its('safe-user-create') { should cmp 1 }
    its('old_passwords') { should_not cmp 1 }
    its('user') { should cmp 'mysql' }
    its('secure-file-priv') { should_not eq nil }
    its('local-infile') { should cmp 0 }
    its('skip-symbolic-links') { should cmp 1 }
    its('skip-show-database') { should eq '' }
    its('skip-grant-tables') { should eq nil }
    its('allow-suspicious-udfs') { should cmp 0 }
  end
end

# Parsing configfiles for unwanted entries
control 'mysql-conf-03b' do
  impact 0.7
  title 'enable secure configurations for mysql'
  only_if('MySQL version less than 8.0.3 and not mariadb') do
    (Gem::Version.new(version.mysql_version) <= Gem::Version.new('8.0.3') and distribution.mysql_distribution == 'mysql')
  end
  describe mysql_conf.params('mysqld') do
    its('secure-auth') { should cmp 1 }
  end
end

# 'Mysql-config: owner, group and permissions'
control 'mysql-conf-04' do
  impact 0.7
  title 'ensure the mysql data path is owned by mysql user'
  describe file(mysql_data_path) do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end
end

control 'mysql-conf-05' do
  impact 0.5
  title 'ensure data path is owned by mysql user'
  describe file("#{mysql_data_path}/ibdata1") do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

control 'mysql-conf-06' do
  impact 0.5
  title 'ensure log file is owned by mysql user'
  describe file(mysql_log_file) do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into mysql_log_group }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

control 'mysql-conf-07' do
  impact 0.7
  title 'ensure the mysql config file is owned by user root, group mysql'
  describe file(mysql_config_file) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'mysql' }
    it { should_not be_readable.by('others') }
  end
end

# test this only if we have a mysql_hardening_file
control 'mysql-conf-08' do
  impact 0.5
  title 'ensure the mysql hardening config file is owned by user root, group mysql'
  describe file(mysql_hardening_file) do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'mysql' }
    it { should_not be_readable.by('others') }
  end
  only_if { command("ls #{mysql_hardening_file}").exit_status.zero? }
end

# 'Mysql environment'
control 'mysql-conf-09' do
  impact 1.0
  title 'the use of MYSQL_PWD is insecure and can exploit the password'
  describe command('env') do
    its(:stdout) { should_not match(/^MYSQL_PWD=/) }
  end
end
