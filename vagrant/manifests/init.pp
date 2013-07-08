exec { 'update':
  command => '/usr/bin/apt-get update'
}

package { ["apache2", 
           "python", 
           "python-pip", 
           "python-pgsql", 
           "postgresql", 
           "vim", 
           "git-core"]:
  ensure => present,
  before => [Exec["setup"], Exec["unipath"], Exec["compressor"], Exec["git"]],
  require=> Exec["update"]
}

file { ['/var/www', '/var/www/breeze']:
   ensure => 'directory',
   owner => 'www-data',
   group => 'www-data',
   mode => 0755,
   before => Exec["git"]
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

exec {'compressor':
  command => '/usr/bin/pip install django_compressor',
  cwd => '/var/www/breeze'
}


