require 'rubygems'
require 'sinatra'
require 'cgi'

set :port, 59623

get '/play' do
  unescapedUrl = CGI.unescape(params[:p])
  `mplayer -fs -cache 8192 "#{unescapedUrl}" &`
  "Just played #{unescapedUrl}"
end

