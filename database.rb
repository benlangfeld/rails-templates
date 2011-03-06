create_file "config/database.example.yml", :force => true do
"setup: &setup
  adapter: #{options[:database]}
  encoding: utf8
  host: localhost
  pool: 5

development:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/development.sqlite3" : "#{app_name}_development"}

test:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/test.sqlite3" : "#{app_name}_test"}

staging:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/staging.sqlite3" : "#{app_name}_staging"}

production:
  <<: *setup
  database: #{options[:database] =~ /sqlite3/ ? "db/production.sqlite3" : "#{app_name}_production"}

cucumber:
  <<: *test"
end

run 'cp config/database.example.yml config/database.yml'

bundle

inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
  (" " * 6) + "generator.orm :active_record\n"
end

git :add => ".", :commit => "-m 'Use correct database'"
