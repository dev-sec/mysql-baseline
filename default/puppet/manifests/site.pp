# Configure MySQL Server as you normally would:
class { '::mysql::server':
  root_password    => 'iloverandompasswordsbutthiswilldo'
}

class { '::mysql_hardening':
  provider => 'puppetlabs/mysql'
}
