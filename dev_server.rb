require 'rubygems'
require 'sinatra'

get '/:template' do
  buffer = ''
  filename = File.expand_path("../#{params[:template]}", __FILE__)
  File.open(filename).each do |line|
    buffer += line.gsub(/https:\/\/github.com\/benlangfeld\/rails-templates\/raw\/master/, 'http://localhost:4567')
  end
  buffer
end