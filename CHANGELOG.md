# Changelog

## [4.0.5](https://github.com/dev-sec/mysql-baseline/tree/4.0.5) (2022-03-18)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/4.0.4...4.0.5)

**Merged pull requests:**

- Change linting to Cookstyle [\#71](https://github.com/dev-sec/mysql-baseline/pull/71) ([schurzi](https://github.com/schurzi))

## [4.0.4](https://github.com/dev-sec/mysql-baseline/tree/4.0.4) (2022-01-12)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/4.0.3...4.0.4)

**Implemented enhancements:**

- use service name for process check instead of hardcoding it [\#65](https://github.com/dev-sec/mysql-baseline/pull/65) ([rndmh3ro](https://github.com/rndmh3ro))

**Fixed bugs:**

- fix service process control check [\#67](https://github.com/dev-sec/mysql-baseline/pull/67) ([rndmh3ro](https://github.com/rndmh3ro))

**Closed issues:**

- secure-auth is deprecated in MySQL 8.0.3 [\#58](https://github.com/dev-sec/mysql-baseline/issues/58)

**Merged pull requests:**

- use input instead of attribute [\#70](https://github.com/dev-sec/mysql-baseline/pull/70) ([micheelengronne](https://github.com/micheelengronne))
- format and update README.md [\#69](https://github.com/dev-sec/mysql-baseline/pull/69) ([schurzi](https://github.com/schurzi))
- add dependency to chef-config for CI [\#66](https://github.com/dev-sec/mysql-baseline/pull/66) ([schurzi](https://github.com/schurzi))
- use version tag for changelog action [\#64](https://github.com/dev-sec/mysql-baseline/pull/64) ([schurzi](https://github.com/schurzi))
- Fix lint [\#63](https://github.com/dev-sec/mysql-baseline/pull/63) ([schurzi](https://github.com/schurzi))
- add github action for testing [\#62](https://github.com/dev-sec/mysql-baseline/pull/62) ([rndmh3ro](https://github.com/rndmh3ro))

## [4.0.3](https://github.com/dev-sec/mysql-baseline/tree/4.0.3) (2020-10-20)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/4.0.2...4.0.3)

**Fixed bugs:**

- fix quotes in library again [\#61](https://github.com/dev-sec/mysql-baseline/pull/61) ([rndmh3ro](https://github.com/rndmh3ro))

## [4.0.2](https://github.com/dev-sec/mysql-baseline/tree/4.0.2) (2020-10-20)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/4.0.1...4.0.2)

**Closed issues:**

- Dynamically determine logfile path [\#53](https://github.com/dev-sec/mysql-baseline/issues/53)
- mysql 5.7.6 password -\> authentication\_string [\#35](https://github.com/dev-sec/mysql-baseline/issues/35)

**Merged pull requests:**

- fix mysql\_version command [\#60](https://github.com/dev-sec/mysql-baseline/pull/60) ([rndmh3ro](https://github.com/rndmh3ro))
- use custom resource to get mysql version and distribution [\#59](https://github.com/dev-sec/mysql-baseline/pull/59) ([rndmh3ro](https://github.com/rndmh3ro))
- check if a password column exists and only then check contents [\#57](https://github.com/dev-sec/mysql-baseline/pull/57) ([rndmh3ro](https://github.com/rndmh3ro))

## [4.0.1](https://github.com/dev-sec/mysql-baseline/tree/4.0.1) (2020-08-28)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/4.0.0...4.0.1)

**Merged pull requests:**

- only run password-checks when the appropriate columns exist [\#52](https://github.com/dev-sec/mysql-baseline/pull/52) ([rndmh3ro](https://github.com/rndmh3ro))

## [4.0.0](https://github.com/dev-sec/mysql-baseline/tree/4.0.0) (2020-08-26)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.7...4.0.0)

**Merged pull requests:**

- BREAKING: config-files should be owned by mysql-user [\#56](https://github.com/dev-sec/mysql-baseline/pull/56) ([rndmh3ro](https://github.com/rndmh3ro))

## [3.1.7](https://github.com/dev-sec/mysql-baseline/tree/3.1.7) (2020-08-17)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.6...3.1.7)

**Fixed bugs:**

- fix wrong parameter in new dynamic determination [\#55](https://github.com/dev-sec/mysql-baseline/pull/55) ([rndmh3ro](https://github.com/rndmh3ro))

## [3.1.6](https://github.com/dev-sec/mysql-baseline/tree/3.1.6) (2020-08-12)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.5...3.1.6)

**Closed issues:**

- CentOS 7 and 8 logfile is /var/log/mariadb/mariadb.log [\#50](https://github.com/dev-sec/mysql-baseline/issues/50)

**Merged pull requests:**

-  dynamically define mysql datadir and log\_error  [\#54](https://github.com/dev-sec/mysql-baseline/pull/54) ([rndmh3ro](https://github.com/rndmh3ro))

## [3.1.5](https://github.com/dev-sec/mysql-baseline/tree/3.1.5) (2020-08-05)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.4...3.1.5)

**Merged pull requests:**

- change log path and name for centos\>7 [\#51](https://github.com/dev-sec/mysql-baseline/pull/51) ([rndmh3ro](https://github.com/rndmh3ro))

## [3.1.4](https://github.com/dev-sec/mysql-baseline/tree/3.1.4) (2020-07-23)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.3...3.1.4)

**Merged pull requests:**

- The release draft references the correct SHA [\#49](https://github.com/dev-sec/mysql-baseline/pull/49) ([micheelengronne](https://github.com/micheelengronne))

## [3.1.3](https://github.com/dev-sec/mysql-baseline/tree/3.1.3) (2020-07-13)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.2...3.1.3)

**Merged pull requests:**

- Change default: to value: [\#48](https://github.com/dev-sec/mysql-baseline/pull/48) ([enzomignogna](https://github.com/enzomignogna))

## [3.1.2](https://github.com/dev-sec/mysql-baseline/tree/3.1.2) (2020-06-18)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.1...3.1.2)

**Merged pull requests:**

- version alignment [\#47](https://github.com/dev-sec/mysql-baseline/pull/47) ([micheelengronne](https://github.com/micheelengronne))

## [3.1.1](https://github.com/dev-sec/mysql-baseline/tree/3.1.1) (2020-06-18)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.1.0...3.1.1)

**Merged pull requests:**

- github actions release [\#46](https://github.com/dev-sec/mysql-baseline/pull/46) ([micheelengronne](https://github.com/micheelengronne))

## [3.1.0](https://github.com/dev-sec/mysql-baseline/tree/3.1.0) (2019-05-15)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/3.0.0...3.1.0)

**Merged pull requests:**

- Bump version to 3.1.0 and switch to inspec 3 for check [\#45](https://github.com/dev-sec/mysql-baseline/pull/45) ([alexpop](https://github.com/alexpop))
- Change version string comparison [\#44](https://github.com/dev-sec/mysql-baseline/pull/44) ([rndmh3ro](https://github.com/rndmh3ro))
- Update issue templates [\#43](https://github.com/dev-sec/mysql-baseline/pull/43) ([artem-sidorenko](https://github.com/artem-sidorenko))
- update rubocop gem dependency [\#42](https://github.com/dev-sec/mysql-baseline/pull/42) ([chris-rock](https://github.com/chris-rock))
- add missing impact and title to inspec control [\#41](https://github.com/dev-sec/mysql-baseline/pull/41) ([chris-rock](https://github.com/chris-rock))

## [3.0.0](https://github.com/dev-sec/mysql-baseline/tree/3.0.0) (2018-05-04)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/2.2.0...3.0.0)

**Merged pull requests:**

- use inspec controls [\#40](https://github.com/dev-sec/mysql-baseline/pull/40) ([chris-rock](https://github.com/chris-rock))

## [2.2.0](https://github.com/dev-sec/mysql-baseline/tree/2.2.0) (2018-05-04)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/2.1.0...2.2.0)

**Closed issues:**

- mysql\_log\_path/file should not be checked [\#33](https://github.com/dev-sec/mysql-baseline/issues/33)

**Merged pull requests:**

- 2.2.0 [\#39](https://github.com/dev-sec/mysql-baseline/pull/39) ([chris-rock](https://github.com/chris-rock))
- remove logfile check [\#38](https://github.com/dev-sec/mysql-baseline/pull/38) ([rndmh3ro](https://github.com/rndmh3ro))
- use recommended spdx license identifier [\#37](https://github.com/dev-sec/mysql-baseline/pull/37) ([chris-rock](https://github.com/chris-rock))

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

## [1.1.0](https://github.com/dev-sec/mysql-baseline/tree/1.1.0) (2014-09-11)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/1.0.0...1.1.0)

**Merged pull requests:**

- make sure conf files are not writable or executable by others [\#16](https://github.com/dev-sec/mysql-baseline/pull/16) ([arlimus](https://github.com/arlimus))
- install server and apply hardening in seperate steps [\#14](https://github.com/dev-sec/mysql-baseline/pull/14) ([chris-rock](https://github.com/chris-rock))
- root should be owner of mysql config [\#13](https://github.com/dev-sec/mysql-baseline/pull/13) ([chris-rock](https://github.com/chris-rock))

## [1.0.0](https://github.com/dev-sec/mysql-baseline/tree/1.0.0) (2014-08-13)

[Full Changelog](https://github.com/dev-sec/mysql-baseline/compare/498e61287ce653cd1dce5b867c9f112f5bc0776a...1.0.0)

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



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
