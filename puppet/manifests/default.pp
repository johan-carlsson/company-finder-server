$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# Preinstall
stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# MySQL 
class install_mysql {
  class { 'mysql': }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' }
  }

  database_user { 'rails@localhost':
    ensure  => present,
    require => Class['mysql::server']
  }

  package { 'libmysqlclient15-dev':
    ensure => installed
  }
}
class { 'install_mysql': }


# Packages 
package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

package { 'vim':
  ensure => installed
}

package { 'tmux':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# Ruby
exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.1.1 && rvm alias create default 2.1.1'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm']
}

exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}

# Company finder
exec { 'setup company-finder-server':
  command => "${as_vagrant} 'rvm use 2.1.1@company-finder --create;cd /vagrant/;bundle install;rake db:setup;'",
  require => Exec['install_rvm']
}

