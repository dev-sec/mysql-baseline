# Configure MySQL Server as you normally would:
class { 'mysql::server':
}

class { 'mysql_hardening':  
  provider => 'puppetlabs/mysql'
}
