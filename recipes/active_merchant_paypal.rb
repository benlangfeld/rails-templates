@strategies << lambda do
  create_file "config/active_merchant_paypal.example.yml" do
    <<-PAYPAL
    login: blah
    password: blah
    signature: blah
    PAYPAL
  end

  append_file '.gitignore', "config/active_merchant_paypal.yml\n"

  run 'cp config/active_merchant_paypal.example.yml config/active_merchant_paypal.yml'

  create_file "config/initializers/active_merchant_paypal.rb" do
    <<-PAYPAL
    config_filename = "#{Rails.root}/config/active_merchant_paypal.yml"
    config = if File.exists?(config_filename)
      c = YAML.load_file config_filename
      {:login => c['login'], :password => c['password'], :signature => c['signature']}
    else
      {:login => ENV['PP_LOGIN'], :password => ENV['PP_PASSWORD'], :signature => ENV['PP_SIGNATURE']}
    end

    $paypal = ActiveMerchant::Billing::PaypalGateway.new config
    PAYPAL
  end

  commit_all 'Add ActiveMerchant PayPal config'
end
