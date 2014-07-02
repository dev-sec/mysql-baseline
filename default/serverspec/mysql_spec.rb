# encoding: utf-8

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

# set OS-dependent filenames and paths
case backend.check_os[:family]
when 'Ubuntu'
  mysql_config_file = '/etc/mysql/my.cnf'
  mysql_hardening_file = '/etc/mysql/conf.d/hardening.cnf'
  mysql_config_path = '/etc/mysql/'
  mysql_data_path = '/var/lib/mysql/'
  mysql_log_path = '/var/log/'
  service_name = 'mysql'
when 'RedHat', 'Fedora'
  mysql_config_file = '/etc/my.cnf'
  mysql_hardening_file = '/etc/hardening.cnf'
  mysql_config_path = '/etc/'
  mysql_data_path = '/var/lib/mysql/'
  mysql_log_path = '/var/log/'
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

  # Req. 294 (keine Community-version)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select version();' | tail -1") do
    its(:stdout) { should_not match(/Community/) }
  end

  # Req. 296 (version > 5)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select substring(version(),1,1);' | tail -1") do
    its(:stdout) { should match(/^5/) }
  end

  # Req. 297 (keine default-datenbanken)
  describe command("mysql -uroot -p#{ENV['mysql_password']} -s -e 'show databases like \"test\";'") do
    its(:stdout) { should_not match(/test/) }
  end

  # Req. 298 (keine anonymous-benutzer)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # Req. 300 (keine benutzerkonten ohne kennwort)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where length(password)=0 or password=\"\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # Req. 317 (no grant privileges)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where grant_priv=\"y\" and User!=\"root\" and User!=\"debian-sys-maint\";' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # Req. 321 (keine host-wildcards)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where host=\"%\"' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

  # Req. 322 (root-login nur von localhost)
  describe command("mysql -uroot -p#{ENV['mysql_password']} mysql -s -e 'select count(*) from mysql.user where user=\"root\" and host not in (\"localhost\",\"127.0.0.1\",\"::1\")' | tail -1") do
    its(:stdout) { should match(/^0/) }
  end

end

# Req. 299 (nur eine instanz pro server)
describe 'Req. 299: check for multiple instances' do
  describe command('ps aux | grep mysqld | grep -v grep | wc -l') do
    its(:stdout) { should match(/^1$/) }
  end
end

describe 'Parsing configfiles for unwanted entries' do

  # Req. 301 (safe-user-create = 1)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('safe-user-create', '1') }
  end

  # Req. 302 (no old_passwords)
  describe file(tmp_config_file) do
    its(:content) { should_not match_key_value('old_passwords', '1') }
  end

  # Req. 305 (user = mysql)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('user', 'mysql') }
  end

  # Req. 307 (skip-symbolic-links = 1)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('skip-symbolic-links', '1') }
  end

  # Req. 309 (secure-file-priv)
  describe file(tmp_config_file) do
    its(:content) { should match(/^\s*?secure-file-priv/) }
  end

  # Req. 310 (local-infile = 0)
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('local-infile', '0') }
  end

  # Req. 315 (skip-show-database)
  describe file(tmp_config_file) do
    its(:content) { should match(/^\s*?skip-show-database/) }
  end

  # Req. 316 (skip-grant-tables)
  describe file(tmp_config_file) do
    it { should_not contain 'skip-grant-tables' }
  end

  # Req. 320 (kein "allow-suspicious-udfs")
  describe file(tmp_config_file) do
    its(:content) { should match_key_value('allow-suspicious-udfs', '0') }
  end

end

# Req. 311, 312, 313
describe 'Req. 311, 312, 313: Mysql-data owner, group and permissions' do

  describe file(mysql_data_path) do
    it { should be_directory }
  end

  describe file(mysql_data_path) do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file("#{mysql_data_path}/ibdata1") do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file(mysql_log_path) do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  describe file("#{mysql_log_path}/mysql.log") do
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'adm' }
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
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

end
