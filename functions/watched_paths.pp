function certificate_checker::watched_paths() >> Array[Stdlib::Absolutepath] {
  $pql = "resources [parameters] { type = 'Certificate_checker::Watch' and certname = '${trusted['certname']}' }"
  puppetdb_query($pql).map |$value| { $value.dig('parameters', 'paths') }.flatten().unique().sort()
}
