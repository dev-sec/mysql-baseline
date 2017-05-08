# Change Log

## [2.1.0](https://github.com/dev-sec/mysql-baseline/tree/2.1.0) (2017-05-08)
[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/2.0.0...2.1.0)

**Merged pull requests:**

- Update metadata [\#36](https://github.com/dev-sec/mysql-baseline/pull/36) ([chris-rock](https://github.com/chris-rock))
- update centos7 service name [\#34](https://github.com/dev-sec/mysql-baseline/pull/34) ([rndmh3ro](https://github.com/rndmh3ro))
- restrict ruby testing to version 2.3.3 and update gemfile [\#32](https://github.com/dev-sec/mysql-baseline/pull/32) ([atomic111](https://github.com/atomic111))
- streamline config owner, remove duplicate [\#31](https://github.com/dev-sec/mysql-baseline/pull/31) ([rndmh3ro](https://github.com/rndmh3ro))

## [2.0.0](https://github.com/dev-sec/mysql-baseline/tree/2.0.0) (2017-01-02)
[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/1.2.0...2.0.0)

**Merged pull requests:**

- ensure the mysql config file permission is verified [\#30](https://github.com/dev-sec/mysql-baseline/pull/30) ([chris-rock](https://github.com/chris-rock))
- migrate from Serverspec to InSpec [\#29](https://github.com/dev-sec/mysql-baseline/pull/29) ([chris-rock](https://github.com/chris-rock))

## [1.2.0](https://github.com/dev-sec/mysql-baseline/tree/1.2.0) (2015-10-15)
[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/1.1.0...1.2.0)

**Merged pull requests:**

- add ansible support [\#27](https://github.com/dev-sec/mysql-baseline/pull/27) ([rndmh3ro](https://github.com/rndmh3ro))
- update urls [\#26](https://github.com/dev-sec/mysql-baseline/pull/26) ([chris-rock](https://github.com/chris-rock))
- add json format option [\#25](https://github.com/dev-sec/mysql-baseline/pull/25) ([atomic111](https://github.com/atomic111))
- tmp files considered harmful, move the tmp file to /root so that only root can [\#24](https://github.com/dev-sec/mysql-baseline/pull/24) ([ehaselwanter](https://github.com/ehaselwanter))
- Update common [\#23](https://github.com/dev-sec/mysql-baseline/pull/23) ([arlimus](https://github.com/arlimus))
- Update common [\#22](https://github.com/dev-sec/mysql-baseline/pull/22) ([arlimus](https://github.com/arlimus))
- updating common files [\#21](https://github.com/dev-sec/mysql-baseline/pull/21) ([arlimus](https://github.com/arlimus))
- move to serverspec2 [\#20](https://github.com/dev-sec/mysql-baseline/pull/20) ([ehaselwanter](https://github.com/ehaselwanter))
- add percona test role [\#18](https://github.com/dev-sec/mysql-baseline/pull/18) ([chris-rock](https://github.com/chris-rock))

## [1.1.0](https://github.com/dev-sec/mysql-baseline/tree/1.1.0) (2014-09-11)
[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/1.0.0...1.1.0)

**Merged pull requests:**

- Dtag sec 3.24 9 [\#17](https://github.com/dev-sec/mysql-baseline/pull/17) ([arlimus](https://github.com/arlimus))
- make sure conf files are not writable or executable by others [\#16](https://github.com/dev-sec/mysql-baseline/pull/16) ([arlimus](https://github.com/arlimus))
- install server and apply hardening in seperate steps [\#14](https://github.com/dev-sec/mysql-baseline/pull/14) ([chris-rock](https://github.com/chris-rock))
- root should be owner of mysql config [\#13](https://github.com/dev-sec/mysql-baseline/pull/13) ([chris-rock](https://github.com/chris-rock))

## [1.0.0](https://github.com/dev-sec/mysql-baseline/tree/1.0.0) (2014-08-13)
**Merged pull requests:**

- added kitchen test for secure-auth optionen and updated requirement number [\#12](https://github.com/dev-sec/mysql-baseline/pull/12) ([atomic111](https://github.com/atomic111))
- Ensure serverspec does not fail with wrong cli languages [\#11](https://github.com/dev-sec/mysql-baseline/pull/11) ([chris-rock](https://github.com/chris-rock))
- test only if we have distinct hardening file. \(not the case in the puppet [\#10](https://github.com/dev-sec/mysql-baseline/pull/10) ([ehaselwanter](https://github.com/ehaselwanter))
- update tests for all supported plattform [\#9](https://github.com/dev-sec/mysql-baseline/pull/9) ([ehaselwanter](https://github.com/ehaselwanter))
- add some GIS requirements [\#8](https://github.com/dev-sec/mysql-baseline/pull/8) ([ehaselwanter](https://github.com/ehaselwanter))
- update with common rubocop stuff and fixes [\#7](https://github.com/dev-sec/mysql-baseline/pull/7) ([ehaselwanter](https://github.com/ehaselwanter))
- add standalone usage to mysql test [\#6](https://github.com/dev-sec/mysql-baseline/pull/6) ([ehaselwanter](https://github.com/ehaselwanter))
- add lockfiles and delete them from tree [\#5](https://github.com/dev-sec/mysql-baseline/pull/5) ([ehaselwanter](https://github.com/ehaselwanter))
- streamline .rubocop config [\#4](https://github.com/dev-sec/mysql-baseline/pull/4) ([ehaselwanter](https://github.com/ehaselwanter))
- rubocop fixes [\#3](https://github.com/dev-sec/mysql-baseline/pull/3) ([ehaselwanter](https://github.com/ehaselwanter))
- add puppet configs for the default test suite [\#2](https://github.com/dev-sec/mysql-baseline/pull/2) ([ehaselwanter](https://github.com/ehaselwanter))
- add the tests from https://github.com/TelekomLabs/chef-mysql-hardening [\#1](https://github.com/dev-sec/mysql-baseline/pull/1) ([ehaselwanter](https://github.com/ehaselwanter))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*