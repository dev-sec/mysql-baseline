# frozen_string_literal: true

# Copyright:: 2020, Sebastian Gumprich
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
# author: Sebastian Gumprich

class MySQLDistribution < Inspec.resource(1)
  name 'mysql_distribution'

  attr_reader :user, :pass

  def initialize(user, pass)
    super()
    @user = user
    @pass = pass
  end

  def mysql_distribution
    if inspec.command("mysql -u#{user} -p#{pass} -sN -e 'SHOW VARIABLES WHERE Variable_name = \"version_comment\"'").stdout.strip.split("\t")[1].downcase.include? 'mariadb'
      'mariadb'
    else
      'mysql'
    end
  end
end
