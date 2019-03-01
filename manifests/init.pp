class certificate_checker (
  String $logfile = '/var/log/certificate-checker.jsonl',
  String $ensure = 'installed',

  $hour = '*/4',
  $minute = fqdn_rand(60),
  $month = undef,
  $monthday = undef,
  $weekday = undef,

  Optional[String] $user = undef,
  Optional[String] $group = undef,
) {
  package { 'certificate-checker':
    ensure   => $ensure,
    provider => 'gem',
  }

  file { $logfile:
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

  $args = certificate_checker::watched_paths().join(' ')

  cron { 'certificate-checker':
    command  => "/usr/local/bin/certificate-checker -o ${logfile} ${args}",

    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,

    user     => $user,
  }
}
