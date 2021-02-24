require 'spec_helper_acceptance'

describe 'certificate_checker class' do
  it 'works idempotently with no errors' do
    pp = <<~MANIFEST
      function puppetdb_query(String $pql) {
        []
      }

      class { 'certificate_checker':
      }
    MANIFEST

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end
end
