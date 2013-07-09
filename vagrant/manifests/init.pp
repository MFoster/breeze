exec { 'update':
  command => '/usr/bin/apt-get update'
}

package { ["apache2", 
           "python", 
           "python-pip", 
           "python-mysqldb",
           "python-software-properties", 
           "mysql-server", 
           "vim", 
           "git-core"]:
  ensure => present,
  before => [Exec["setup"], Exec["unipath"], Exec["compressor"], Exec["git"], Exec["pyyaml"]],
  require=> Exec["update"]
}

file { ['/var/www', '/var/www/breeze']:
   ensure => 'directory',
   owner => 'www-data',
   group => 'www-data',
   mode => 0755,
   before => Exec["git"]
}


exec {'node-update':
  command => '/usr/bin/apt-get update',
  subscribe => Exec["add-node-repo"]
}


package{'nodejs':
  require => Exec['node-update'],
  before => [Exec['sass'], Exec['coffee']]
}


exec {'add-node-repo':
  command => '/usr/bin/add-apt-repository ppa:chris-lea/node.js',
  require => Exec['setup']
}

exec {'sass':
  command => '/opt/vagrant_ruby/bin/gem install sass'
}

exec {'coffee': 
  command => '/usr/bin/npm install -g coffee-script'
}

exec {'git':
  command => '/usr/bin/git clone https://github.com/MFoster/breeze.git breeze',
  cwd => '/var/www'
}
exec {'setup':
  command => '/usr/bin/python setup.py install',
  cwd => '/var/www/breeze'
}
exec {'unipath':
  command => '/usr/bin/pip install unipath',
  cwd => '/var/www/breeze'
}

exec {'pyyaml':
  command => '/usr/bin/pip install pyyaml',
  cwd => '/var/www/breeze'
}

exec {'compressor':
  command => '/usr/bin/pip install django_compressor',
  cwd => '/var/www/breeze'
}


