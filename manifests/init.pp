# @summary Configure certificate_checker
#
# @param package_provider
# @param certificate_checker_path
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
  Enum['gem', 'puppet_gem'] $package_provider,
  String                    $certificate_checker_path,

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
    provider => $package_provider,
  }

  file { $logfile:
    ensure => file,
    owner  => $user,
    group  => $group,
    mode   => '0644',
  }

  $args = certificate_checker::watched_paths().join(' ')

  cron { 'certificate-checker':
    command  => "${certificate_checker_path} -o ${logfile} ${args}",

    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,

    user     => $user,
  }
}
