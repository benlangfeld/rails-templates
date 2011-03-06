gem "jquery-rails"

stategies << lambda do
  generate "jquery:install", "--ui"
  git :add => ".", :rm => "public/javascripts/controls.js public/javascripts/dragdrop.js public/javascripts/effects.js public/javascripts/prototype.js", :commit => "-m 'Use jQuery'"
end
