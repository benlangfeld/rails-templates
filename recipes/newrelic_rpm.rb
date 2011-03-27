gem "newrelic_rpm"

@stategies << lambda do
  get "https://rpm.newrelic.com/accounts/#{SETTINGS['newrelic_rpm']['account_id']}/newrelic.yml"
  commit_all 'Use Newrelic RPM'
end
