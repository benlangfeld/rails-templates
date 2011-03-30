gem "jquery-rails"

@strategies << lambda do
  generate "jquery:install", "--ui", "-f"
  git :add => ".", :rm => "public/javascripts/controls.js public/javascripts/dragdrop.js public/javascripts/effects.js public/javascripts/prototype.js", :commit => "-m 'Use jQuery'"
end
