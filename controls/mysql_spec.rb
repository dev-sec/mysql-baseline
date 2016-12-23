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

user = attribute('User', description: 'MySQL database user', default: 'root', required: true)
pass = attribute('Password', description: 'MySQL database password', default: 'iloverandompasswordsbutthiswilldo', required: true)

mysql_hardening_file = '/etc/mysql/conf.d/hardening.cnf'

# set OS-dependent filenames and paths
case os[:family]
when 'ubuntu', 'debian'
  mysql_config_file = '/etc/mysql/my.cnf'
  mysql_config_path = '/etc/mysql/'
  mysql_data_path = '/var/lib/mysql/'
  mysql_log_path = '/var/log/'
  mysql_log_file = 'mysql.log'
  mysql_log_group = 'adm'
  os[:release] == '14.04' ? mysql_log_dir_group = 'syslog' : mysql_log_dir_group = 'root'
  service_name = 'mysql'
when 'redhat', 'fedora'
  mysql_config_file = '/etc/my.cnf'
  mysql_config_path = '/etc/'
  mysql_data_path = '/var/lib/mysql/'
  mysql_log_path = '/var/log/'
  mysql_log_file = 'mysqld.log'
  mysql_log_group = 'mysql'
  mysql_log_dir_group = 'root'
  service_name = 'mysqld'
end

describe service("#{service_name}") do
  it { should be_enabled }
  it { should be_running }
end

# Checking MySQL-databases for risky entries
describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select version();' | tail -1") do
  its(:stdout) { should_not match(/Community/) }
end

describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select substring(version(),1,1);' | tail -1") do
  its(:stdout) { should match(/^5/) }
end

describe command("mysql -u#{user} -p#{pass} -s -e 'show databases like \"test\";'") do
  its(:stdout) { should_not match(/test/) }
end

describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select count(*) from mysql.user where user=\"\";' | tail -1") do
  its(:stdout) { should match(/^0/) }
end

describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select count(*) from mysql.user where length(password)=0 or password=\"\";' | tail -1") do
  its(:stdout) { should match(/^0/) }
end

describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select count(*) from mysql.user where grant_priv=\"y\" and User!=\"root\" and User!=\"debian-sys-maint\";' | tail -1") do
  its(:stdout) { should match(/^0/) }
end

describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select count(*) from mysql.user where host=\"%\"' | tail -1") do
  its(:stdout) { should match(/^0/) }
end

describe command("mysql -u#{user} -p#{pass} mysql -s -e 'select count(*) from mysql.user where user=\"root\" and host not in (\"localhost\",\"127.0.0.1\",\"::1\")' | tail -1") do
  its(:stdout) { should match(/^0/) }
end

# 'Check for multiple instances' do
describe command('ps aux | grep mysqld | egrep -v "grep|mysqld_safe|logger" | wc -l') do
  its(:stdout) { should match(/^1$/) }
end

# Parsing configfiles for unwanted entries
describe mysql_conf.params('mysqld') do
  its('safe-user-create') { should cmp 1 }
  its('old_passwords') { should_not cmp 1  }
  its('secure-auth') { should cmp 1  }
  its('user') { should cmp 'mysql' }
  its('skip-symbolic-links') { should cmp 1  }
  its('secure-file-priv') { should_not eq nil }
  its('local-infile') { should cmp 0  }
  its('skip-show-database') { should eq '' }
  its('skip-grant-tables') { should eq nil }
  its('allow-suspicious-udfs') { should cmp 0  }
end

# binding.pry

# 'Mysql-config: owner, group and permissions'
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

describe file(mysql_config_path) do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should_not be_readable.by('others') }
end

# test this only if we have a mysql_hardening_file
if command("ls #{mysql_hardening_file}").exit_status == 0
  describe file(mysql_hardening_file) do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'root' }
    it { should_not be_readable.by('others') }
  end
end


# 'Mysql environment'
describe command('env') do
  its(:stdout) { should_not match(/^MYSQL_PWD=/) }
end
