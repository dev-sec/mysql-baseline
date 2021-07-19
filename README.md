# DevSec MySQL Baseline

This Compliance Profile ensures, that all hardening projects keep the same quality.

- <https://github.com/dev-sec/ansible-collection-hardening/tree/master/roles/mysql_hardening>
- <https://github.com/dev-sec/chef-mysql-hardening>
- <https://github.com/dev-sec/puppet-mysql-hardening>

## Standalone Usage

This Compliance Profile requires [cinc-auditor](https://cinc.sh/start/auditor/) or [InSpec](https://github.com/chef/inspec) for execution:

```bash
git clone https://github.com/dev-sec/mysql-baseline
cinc-auditor exec mysql-baseline
```

You can also execute the profile directly from Github:

```bash
cinc-auditor exec https://github.com/dev-sec/mysql-baseline
```

## License and Author

- Author:: Edmund Haselwanter <me@ehaselwanter.com>
- Author:: Dominik Richter <dominik.richter@googlemail.com>
- Author:: Patrick Muench <patrick.muench1111@googlemail.com>
- Author:: Christoph Hartmann <chris@lollyrock.com>

- Copyright 2014, Deutsche Telekom AG
- Copyright 2014-2016, The Hardening Framework Team
- Copyright 2016-2021, DevSec Hardening Framework Team

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
