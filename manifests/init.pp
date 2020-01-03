# @summary Configure certificate_checker
#
# @param logfile Logfile to store certificates status
# @param ensure
# @param hour
# @param minute
# @param month
# @param monthday
# @param weekday
# @param user User to check certificates status as
# @param group Group to check certificates status as
class certificate_checker (
  String $logfile = '/var/log/certificate-checker.jsonl',
  String $ensure = 'installed',

  Any $hour = '*/4',
  Any $minute = fqdn_rand(60),
  Any $month = undef,
  Any $monthday = undef,
  Any $weekday = undef,

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
