require 'spec_helper'

describe 'certificate_checker' do
  before do
    Puppet::Parser::Functions.newfunction(:puppetdb_query, type: :rvalue) do |_args|
      [
        {
          'parameters' => {
            'paths' => [
              '/a.pem',
              '/b.pem',
            ],
          },
        },
        {
          'parameters' => {
            'paths' => [
              '/b.pem',
              '/c.pem',
            ],
          },
        },
      ]
    end
  end

  it { is_expected.to compile }
  it { is_expected.to contain_cron('certificate-checker').with(command: '/usr/local/bin/certificate-checker --output=/var/log/certificate-checker.jsonl /a.pem /b.pem /c.pem') }

  context 'with ignore_nonexistent' do
    let(:params) do
      {
        ignore_nonexistent: true,
      }
    end

    it { is_expected.to contain_cron('certificate-checker').with(command: '/usr/local/bin/certificate-checker --output=/var/log/certificate-checker.jsonl --ignore-nonexistent /a.pem /b.pem /c.pem') }
  end
end
