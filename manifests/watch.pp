# @summary Add certificates to monitor
#
# @param paths Paths to certificates to monitor
define certificate_checker::watch (
  Variant[Array[Stdlib::Absolutepath], Stdlib::Absolutepath] $paths = $title,
) {
}
