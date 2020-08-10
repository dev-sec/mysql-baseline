# encoding: utf-8

# Copyright 2014, Deutsche Telekom AG
# Copyright 2018, Christoph Hartmann
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

user = attribute('User', description: 'MySQL database user', value: 'root', required: true)
pass = attribute('Password', description: 'MySQL database password', value: 'iloverandompasswordsbutthiswilldo', required: true)

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

control 'mysql-db-05' do
  impact 1.0
  title 'default passwords must be changed'
  describe command("mysql -u#{user} -p#{pass} -sN -e 'select count(*) from mysql.user where length(password)=0 or password=\"\";'") do
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
