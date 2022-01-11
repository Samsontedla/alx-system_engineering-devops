# Puppet for NginX Configuration
exec { 'nginx stable repository download':
command => 'sudo add-apt-repository ppa:nginx/stable',
path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin',
}

exec { 'update all packages':
command => 'sudo apt-get update',
path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin',
}

package { 'nginx':
ensure => 'installed',
}

exec { 'nginx allow http':
command => "ufw allow 'Nginx HTTP'",
path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin',
}

exec { 'chmod for www/':
command => 'chmod -R 755 /var/www',
path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/bin',
}

file { '/va/www/html/index.html':
content => 'Hello World!\n',
}
file { '/var/www/html/custom_404.html':
content => 'Ceci n'est pas une page\n',
}
file { 'Nginx config':
ensure  => file,
  path    => '/etc/nginx/sites-enabled/default',
  content =>
"server {
        listen 80 default_server;
        listen [::]:80 default_server;
               root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        add_header X-Served-By \$hostname;
        location / {
                  # if file fails, fall back to displaying a 404.
                try_files \$uri \$uri/ =404;
        }
        error_page 404 /404.html;
        location  /404.html {
            internal;
        }
        
        if (\$request_filename ~ redirect_me){
            rewrite ^ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
        }
}
",
}
exec { 'rstart nginx service':
command => 'service nginx restart',
path    => '/usr/local/sbin:/usr/bin:/usr/sbin:/bin',
}
service { 'nginx':
ensure  => 'running',
require => Package['nginx'],
}
