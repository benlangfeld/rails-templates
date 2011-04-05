gem 'active_merchant'

@strategies << lambda do
  commit_all 'Use ActiveMerchant'
end
