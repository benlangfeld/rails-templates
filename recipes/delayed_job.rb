gem 'delayed_job'

@strategies << lambda do
  generate 'delayed_job'

  commit_all 'Use Delayed Job'
end
