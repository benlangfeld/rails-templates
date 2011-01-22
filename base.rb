def y?(s)
  yes? "\n#{s} (y/n)"
end

def maybe_update_file(options = {})
  old_contents = File.read options[:file]
  look_for = options[:after] || options[:before] # but not both!
  return if options[:unless_present] && old_contents =~ options[:unless_present]

  if options[:action].nil? || y?("Should I #{options[:action]} to #{options[:file]}?")
    File.open(options[:file], "w") do |file|
      file.print old_contents.sub(look_for, "#{look_for}\n#{options[:content]}") if options[:after]
      file.print old_contents.sub(look_for, "#{options[:content]}\n#{look_for}") if options[:before]
    end

    if old_contents.scan(look_for).length > 1
      puts "\nNOTE: #{options[:file]} may not have been updated correctly, so please take a look at it.\n"
    end
  end
end

gem "nifty-generators"

run "bundle install"

git :init

run "echo 'TODO add readme content' > README"
run "find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;"
run "cp config/database.yml config/database.yml.example"
run "rm public/images/rails.png"
run "rm public/index.html"

run "echo 'config/database.yml' >> .gitignore"

git :add => ".", :commit => "-m 'Base Rails app (with nifty generators)'"

if yes?("Do you want to use mysql?")

end

if yes?("Do you want to use has_scope?")

end

if yes?("Do you want to use simple_enum?")

end

if yes?("Do you want to use andand?")

end

if yes?("Do you want to annotate your models?")

end

if yes?("Add a simple static home page?")
  apply "https://github.com/benlangfeld/rails-templates/raw/master/static.rb"
end

apply "https://github.com/benlangfeld/rails-templates/raw/master/views.rb"

apply "https://github.com/benlangfeld/rails-templates/raw/master/testing.rb"

apply "https://github.com/benlangfeld/rails-templates/raw/master/authorization.rb"

# if yes?("Use ActiveRecord session store?")
#   rake('db:sessions:create')
#   initializer 'session_store.rb', <<-FILE
#     ActionController::Base.session = { :session_key => '_#{(1..6).map { |x| (65 + rand(26)).chr }.join}_session', :secret => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}' }
#     ActionController::Base.session_store = :active_record_store
#   FILE
#
# end

if yes?("Host on GitHub?")
  apply "https://github.com/benlangfeld/rails-templates/raw/master/github.rb"
end
