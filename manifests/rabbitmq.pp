# = Class: sensu::rabbitmq
#
# Configures Sensu for RabbitMQ
#
# == Parameters
#

class sensu::rabbitmq(
                    $ssl_cert_chain,
                    $ssl_private_key,
                    $port,
                    $host,
                    $user,
                    $password,
                    $vhost
  ) {

  if !defined(Sensu_rabbitmq_config[$::fqdn]) {
    if $ssl_cert_chain != '' {
      file { '/etc/sensu/ssl':
        ensure  => directory,
        owner   => 'sensu',
        group   => 'sensu',
        mode    => '0755',
        require => Package['sensu'],
      }

      if $ssl_cert_chain =~ /^puppet:\/\// {
        file { '/etc/sensu/ssl/cert.pem':
          ensure  => present,
          source  => $ssl_cert_chain,
          owner   => 'sensu',
          group   => 'sensu',
          mode    => '0444',
          require => File['/etc/sensu/ssl'],
          before  => Sensu_rabbitmq_config[$::fqdn],
        }

        Sensu_rabbitmq_config {
          ssl_cert_chain => '/etc/sensu/ssl/cert.pem',
        }
      } else {
        Sensu_rabbitmq_config {
          ssl_cert_chain => $ssl_cert_chain,
        }
      }

      if $ssl_private_key =~ /^puppet:\/\// {
        file { '/etc/sensu/ssl/key.pem':
          ensure  => present,
          source  => $ssl_private_key,
          owner   => 'sensu',
          group   => 'sensu',
          mode    => '0440',
          require => File['/etc/sensu/ssl'],
          before  => Sensu_rabbitmq_config[$::fqdn],
        }
        Sensu_rabbitmq_config {
          ssl_private_key => '/etc/sensu/ssl/key.pem',
        }
      } else {
        Sensu_rabbitmq_config {
          ssl_private_key => $ssl_private_key,
        }
      }
    }

    sensu_rabbitmq_config { $::fqdn:
      port     => $port,
      host     => $host,
      user     => $user,
      password => $password,
      vhost    => $vhost,
    }
  }
}
