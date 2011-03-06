def y?(s)
  yes? "\n#{s} (y/n)", :yellow
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

@templates_path = "https://github.com/benlangfeld/rails-templates/raw/master"

git :init

apply "#{@templates_path}/rvm.rb"
apply "#{@templates_path}/cleanup.rb"

gem "nifty-generators", :group => :development

run "bundle install --quiet"

git :add => ".", :commit => "-m 'Base Rails app (with nifty generators)'"

say "Setting up the staging environment"
run "cp config/environments/production.rb config/environments/staging.rb"
git :add => ".", :commit => "-m 'Add staging environment'"

apply "#{@templates_path}/database.rb"
apply "#{@templates_path}/testing.rb"
apply "#{@templates_path}/authorization.rb"
apply "#{@templates_path}/views.rb"

if y?("Use has_scope?")
  gem "has_scope"
  run "bundle install --quiet"
  git :add => ".", :commit => "-m 'Use has_scope'"
end

if y?("Use simple_enum?")
  gem "simple_enum"
  run "bundle install --quiet"
  git :add => ".", :commit => "-m 'Use simple_enum'"
end

if y?("Use andand?")
  gem "andand"
  run "bundle install --quiet"
  git :add => ".", :commit => "-m 'Use andand'"
end

if y?("Annotate your models?")
  gem "annotate-models", :group => :development
  run "bundle install --quiet"
  run "annotate"
  git :add => ".", :commit => "-m 'Annotate models'"
end

if y?("Use Adhearsion?")
  gem "adhearsion"
  gem "rubigen"
  gem "ahn-rails"
  run "bundle install --quiet"
  run "ahn create adhearsion"
  git :add => ".", :commit => "-m 'Add an Adhearsion app'"
end

if y?("Host on GitHub?")
  apply "#{@templates_path}/github.rb"
end
