# Nginx web server setup and configuration
exec { 'update-apt':
  command => 'apt-get update',
  path    => '/usr/bin:/usr/sbin:/bin'
}

package { 'nginx':
  ensure  => installed,
  require => Exec['update-apt']
}

file { 'Home-Page':
  ensure  => file,
  path    => '/var/www/html/index.html',
  content => 'Hello World!',
  require => Package['nginx']
}

# file { '404-Page':
#   ensure  => file,
#   path    => '/var/www/error/404.html',
#   content => "Ceci n'est pas une page"
# }

file_line { 'Custom-Header':
  ensure  => present,
  path    => '/etc/nginx/sites-available/default',
  after   => 'listen 80 default_server;',
  line    => 'add_header X-Served-By $hostname;',
  require => Package['nginx'],
}

file_line { 'Redirection':
  ensure  => present,
  path    => '/etc/nginx/sites-available/default',
  after   => 'listen 80 default_server;',
  line    => 'rewrite ^/redirect_me https://sketchfab.com/bluepeno/models permanent;',
  require => Package['nginx'],
}

service { 'nginx':
  ensure  => running,
  require => Package['nginx']
}
