# == Class: openswan::config
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Authors
#
# Ayoub Elhamdani <a.elhamdani90@gmail.com>
#
class openswan::config (
  $ensure                   = $openswan::ensure,
  $openswan_package         = $openswan::openswan_pkg,
  $openswan_service         = $openswan::service_name,
  $nat_traversal            = $openswan::nat_traversal,
  $virtual_private          = $openswan::virtual_private,
  $opportunistic_encryption = $openswan::opportunistic_encryption,
  $protostack               = $openswan::protostack,
  $uniqueids                = $openswan::uniqueids,
  $ipsec_conf               = $openswan::ipsec_conf,
  $ipsec_secrets_conf       = $openswan::ipsec_secrets_conf,
  $connections_dir          = $openswan::connections_dir,
  $secrets_dir              = $openswan::secrets_dir
) {
  $ensure_directory = $ensure ? {
    'present' => 'directory',
    default   => 'absent'
  }

  file { $ipsec_conf:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('openswan/ipsec.erb'),
  }

  file { $connections_dir:
    ensure => $ensure_directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0744',
    force  => true,
  }

  file { $ipsec_secrets_conf:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('openswan/ipsec.secrets.erb'),
  }

  if ! defined (File[$secrets_dir]) {
    file { $secrets_dir:
      ensure => $ensure_directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0744',
      force  => true,
    }
  }
}
