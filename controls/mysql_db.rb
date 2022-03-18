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

user = input('user')
pass = input('password')

control 'mysql-db-01' do
  impact 0.3
  title 'use supported mysql version in production'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select version();'") do
    its(:stdout) { should_not match(/Community/) }
  end
end

control 'mysql-db-02' do
  impact 0.5
  title 'use mysql version 5 or higher'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select substring_index(version(),\".\",1);'") do
    its(:stdout) { should cmp >= 5 }
  end
end

control 'mysql-db-03' do
  impact 1.0
  title 'test database must be deleted'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'show databases like \"test\";'") do
    its(:stdout) { should_not match(/test/) }
  end
end

control 'mysql-db-04' do
  impact 1.0
  title 'deactivate annonymous user names'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where user=\"\";'") do
    its(:stdout) { should match(/^0/) }
  end
end

# MySQL 5.7.6 dropped the "password" column in the mysql.user table
# so we have to check if it's there before we check if a password is empty
control 'mysql-db-05' do
  impact 1.0
  title 'default passwords must be changed'
  only_if { command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from information_schema.columns where table_name=\"user\" and table_schema=\"mysql\" and column_name=\"password\";'").stdout.strip == '1' }
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where (length(password)=0 or password=\"\") and (length(authentication_string)=0 or authentication_string=\"\");'") do
    its(:stdout) { should match(/^0/) }
  end
end

# MySQL versions older than 5.7.6 and MariaDB databases still have the
# password column so we need to check if it is empty
control 'mysql-db-05b' do
  impact 1.0
  title 'default passwords must be changed'
  only_if { command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from information_schema.columns where table_name=\"user\" and table_schema=\"mysql\" and column_name=\"password\";'").stdout.strip == '0' }
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where length(authentication_string)=0 or authentication_string=\"\";'") do
    its(:stdout) { should match(/^0/) }
  end
end

control 'mysql-db-06' do
  impact 0.5
  title 'the grant option must not be used'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where grant_priv=\"y\" and User!=\"root\" and User!=\"debian-sys-maint\";'") do
    its(:stdout) { should match(/^0/) }
  end
end

control 'mysql-db-07' do
  impact 0.5
  title 'ensure no wildcards are used for hostnames'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where host=\"%\"'") do
    its(:stdout) { should match(/^0/) }
  end
end

control 'mysql-db-08' do
  impact 0.5
  title 'it must be ensured that superuser can login via localhost only'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where user=\"root\" and host not in (\"localhost\",\"127.0.0.1\",\"::1\")'") do
    its(:stdout) { should match(/^0/) }
  end
end
