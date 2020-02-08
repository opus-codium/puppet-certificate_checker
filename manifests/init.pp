# @summary Configure certificate_checker
#
# @param package_provider
# @param certificate_checker_path
# @param logfile Logfile to store certificates status
# @param ensure
# @param ignore_nonexistent Ignore non-existent files. Requires certificate-checker 1.2+
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

  Boolean $ignore_nonexistent = false,

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

  $command = [
    $certificate_checker_path,
    "--output=${logfile}",
    if $ignore_nonexistent {
      '--ignore-nonexistent'
    },
    $args,
  ].filter |$x| { $x =~ NotUndef }.join(' ')

  cron { 'certificate-checker':
    command  => $command,

    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,

    user     => $user,
  }
}
