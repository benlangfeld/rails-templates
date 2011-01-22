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

templates_path = "https://github.com/benlangfeld/rails-templates/raw/master"

gem "nifty-generators"

run "bundle install"

git :init

apply "#{templates_path}/cleanup.rb"

git :add => ".", :commit => "-m 'Base Rails app (with nifty generators)'"

apply "#{templates_path}/rvm.rb"
apply "#{templates_path}/database.rb"

if yes?("Use has_scope?")

end

if yes?("Use simple_enum?")

end

if yes?("Use andand?")

end

if yes?("Annotate your models?")

end

if yes?("Add a simple static home page?")
  apply "#{templates_path}/static.rb"
end

apply "#{templates_path}/views.rb"
apply "#{templates_path}/testing.rb"
apply "#{templates_path}/authorization.rb"

if yes?("Host on GitHub?")
  apply "#{templates_path}/github.rb"
end
