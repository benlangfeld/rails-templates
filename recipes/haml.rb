gem 'haml'
gem 'haml-rails'

stategies << lambda do
  inject_into_file "config/application.rb", :after => "config.generators do |generator|\n" do
    (" " * 6) + "generator.template_engine :haml\n"
  end

  create_file "config/initializers/haml.rb" do
    <<-HAML
    Haml::Template.options[:attr_wrapper] = '\"'
    Haml::Template.options[:format] = :xhtml
    Sass::Plugin.options[:style] = :expanded
    HAML
  end

  commit_all 'Use HAML'
end
